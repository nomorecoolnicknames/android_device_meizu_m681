#!/system/bin/sh
# Bring telephony up after boot.
#
#  1. rild can deadlock on AT channel contention during its first start; one
#     restart clears it, but only after gsm0710muxd has opened the AT channels.
#  2. Without a readable ICCID DcTracker builds no APN list and the LTE attach
#     never completes; write the attach APN to the modem directly.

LOG=/data/local/tmp/forge-ril-kick.log
exec >>"$LOG" 2>&1
echo "=== $(date) forge-ril-kick start (v2)"

# Never outlive the boot it was started for.
( sleep 900; echo "=== self-kill at 900s"; kill $$ 2>/dev/null ) &

wait_for() {                 # wait_for <label> <max-polls> <interval> <test-cmd...>
    label=$1; max=$2; iv=$3; shift 3
    i=0
    while [ $i -lt "$max" ]; do
        if "$@" >/dev/null 2>&1; then echo "$label: ready after ${i} polls"; return 0; fi
        sleep "$iv"; i=$((i+1))
    done
    echo "$label: TIMED OUT after ${i} polls"; return 1
}

prop_is() { [ "$(getprop "$1")" = "$2" ]; }

wait_for boot_completed 120 5 prop_is sys.boot_completed 1

# Defect 1: the AT channels must exist before rild is restarted.
wait_for at_channels 60 5 test -e /dev/radio/pttycmd1
sleep 20
# Let the radio group create /dev/socket/rild-mal: rild already runs as
# radio when libril binds the socket.
chown root:radio /dev/socket 2>/dev/null
chmod 0775 /dev/socket 2>/dev/null
echo "dev/socket now: $(ls -ld /dev/socket)"

echo "restarting ril-daemon-mtk (defect 1); muxd=$(getprop init.svc.gsm0710muxd)"
setprop ctl.restart ril-daemon-mtk

wait_for sim_loaded 60 5 prop_is gsm.sim.state LOADED
echo "sim.state=$(getprop gsm.sim.state) radio=$(getprop init.svc.ril-daemon-mtk)"

APN=$(getprop persist.m681.ril.attach_apn)
[ -z "$APN" ] && APN=internet.mts.ru
if [ -e /dev/radio/atci1 ]; then
    echo "writing attach apn '$APN' to the modem (defect 2)"
    printf 'AT+ES3G=1,7\r'                   > /dev/radio/atci1
    sleep 3
    printf 'AT+CGDCONT=0,"IP","%s"\r' "$APN" > /dev/radio/atci1
    sleep 3
    printf 'AT+COPS=0\r'                     > /dev/radio/atci1
else
    echo "no /dev/radio/atci1 - skipped"
fi

wait_for registered 40 5 sh -c '[ -n "$(getprop gsm.operator.numeric)" ] && [ "$(getprop gsm.operator.numeric)" != "000000" ]'
echo "result: op=$(getprop gsm.operator.alpha) num=$(getprop gsm.operator.numeric) net=$(getprop gsm.network.type)"
echo "=== done"

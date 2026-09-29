# Meizu M3 Note (m681)

Device tree for the Meizu M3 Note (M681 board) for LineageOS 20.0.

## Specifications

| | |
| --- | --- |
| SoC | MediaTek MT6755 (Helio P10) |
| CPU | 8x Cortex-A53 |
| GPU | Mali-T860 MP2 |
| Display | 1080 x 1920 |
| Kernel | 4.9 prebuilt (`m681_49_defconfig`) |
| Shipped Android | 7.0 (Flyme 6.2.0.2A) |

## Status

- Treble product, vendor layout and compatibility configuration: present
- Boot with the current kernel: untested
- Display, touch, Wi-Fi, Bluetooth: untested
- SIM, LTE, calls: untested
- Camera, audio, sensors, fingerprint: untested
- GPS: untested
- SELinux: permissive

## Building

Sync the LineageOS 20.0 source and add the local manifest:

```sh
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
git clone https://github.com/nomorecoolnicknames/android_local_manifests_meizu -b lineage-20.0 .repo/local_manifests
repo sync
```

The build also needs the prebuilt kernel at
`device/meizu/m681/prebuilt/Image.gz-dtb` and the legacy MediaTek framework
and HAL adaptations for this platform.

```sh
source build/envsetup.sh
breakfast m681
brunch m681
```

More information: [ReMeizu](https://github.com/nomorecoolnicknames/remeizu).

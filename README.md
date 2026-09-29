# Meizu M3 Note (m681)

Device tree for the Meizu M3 Note (M681 board) for LineageOS 18.1.

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

Sync the LineageOS 18.1 source and add these repositories:

- `device/meizu/m681` (this repository)
- `vendor/meizu/m681` (proprietary files for this branch)
- `kernel/meizu/m681` (kernel source, used for headers)
- the prebuilt kernel at `device/meizu/m681/prebuilt/Image.gz-dtb`
- the legacy MediaTek framework and HAL adaptations for this platform

Then build:

```sh
source build/envsetup.sh
breakfast m681
brunch m681
```

More information: [ReMeizu](https://github.com/nomorecoolnicknames/remeizu).

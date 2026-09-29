# Meizu M3 Note (m681)

Device tree for the Meizu M3 Note (M681 board) for LineageOS 16.0.

## Specifications

| | |
| --- | --- |
| SoC | MediaTek MT6755 (Helio P10) |
| Display | 1080 x 1920 |
| Kernel | 3.18 prebuilt |
| Fingerprint | Goodix GF516M |

## Status

- With a 4.4 kernel: boot, display, touch, Wi-Fi, SIM1/LTE and sensors working
- With a 4.4 kernel: camera, microphone/call audio and suspend not working
- With the 3.18 prebuilt kernel selected here: untested
- Bluetooth, fingerprint, GPS: untested
- SELinux: permissive

## Building

Sync the LineageOS 16.0 source (JDK 8) and add these repositories:

- `device/meizu/m681` (this repository)
- `device/meizu/mt6755-common`
- `vendor/meizu/m681` (proprietary files for this branch)
- `vendor/mediatek` with the MTK RIL/HAL integration and telephony headers
- `kernel/meizu/meizu_m6/kernel-3.18` (kernel source, used for headers)
- the prebuilt kernel at `device/meizu/m681/prebuilt-kernel/Image.gz-dtb`

Then build:

```sh
source build/envsetup.sh
breakfast m681
brunch m681
```

`M681_SFOS_BUILD=1` builds the kernel from source instead; it needs
`M681_KERNEL_SOURCE_OVERRIDE` or `M681_M6GRAFT_KERNEL_SOURCE` pointing to the
3.18.140 kernel source and uses `m681_sfos_defconfig`.

More information: [ReMeizu](https://github.com/nomorecoolnicknames/remeizu).

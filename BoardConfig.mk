# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

DEVICE_PATH := device/meizu/m681

# Architecture
# MT6755 has eight ARMv8.0 Cortex-A53 cores; LSE (ARMv8.1) must not be enabled.
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Platform
# LK reports the board as WT6755_66_SZ_L. androidboot.hardware=mt6755 selects
# init.mt6755.rc, which is required to mount /system.
TARGET_BOARD_PLATFORM := mt6755
TARGET_BOOTLOADER_BOARD_NAME := mt6755
TARGET_BOARD_PLATFORM_GPU := mali-t860mp2

# Bootloader
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# OTA assert
BOARD_NAME := m681
TARGET_OTA_ASSERT_DEVICE := m681,m3note

# Display
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 1920
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Partitions
# A-only geometry: recovery 16 MiB, custom 512 MiB, boot 16 MiB, system 2560 MiB.
# There is no stock vendor or dynamic super partition.
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_CACHEIMAGE_PARTITION_SIZE := 452984832
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11674828288

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4

# No A/B, virtual A/B or dynamic partitions. PRODUCT_USE_DYNAMIC_PARTITIONS and
# PRODUCT_BUILD_SUPER_PARTITION are read-only here and default to false.
AB_OTA_UPDATER := false
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Treble uses the stock custom partition (mmcblk0p3, 512 MiB) for /vendor.
# VNDK is selected explicitly; the shipping API continues to describe the stock vendor ABI.
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912
BOARD_VNDK_VERSION := current

# Properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Build hacks
# The Nougat-era blobs are installed with PRODUCT_COPY_FILES, so their
# DT_NEEDED entries are not validated at build time.
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Kernel
# Boot header v0: kernel 0x40080000, ramdisk 0x45000000, tags 0x44000000, page size 2048.
# The base and offsets below reproduce these addresses.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x04f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_TAGS_OFFSET := 0x03f88000
BOARD_MKBOOTIMG_ARGS := --board 1480869018 --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --second_offset $(BOARD_SECOND_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)

# Legacy MTK boot header: no header_version, no dtb in bootimg, no dtbo.
BOARD_BOOT_HEADER_VERSION := 0
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_INCLUDE_RECOVERY_DTBO :=

# androidboot.hardware=mt6755 selects init.mt6755.rc; clk_ignore_unused keeps
# the MTK clock gates from being disabled at late init.
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.hardware=mt6755 androidboot.selinux=permissive androidboot.usb.config=adb buildvariant=userdebug clk_ignore_unused

# First-stage mount uses by-name paths from fstab.mt6755, so
# androidboot.partition_map is not needed (MTK LK also appends its own cmdline).

# The selected prebuilt contains the BPF interfaces needed by this Android branch.
# Kernel source and configuration are still required for UAPI headers.
# Force-prebuilt avoids unintentionally rebuilding the kernel during the Android build.
TARGET_NO_KERNEL := false
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/meizu/m681
TARGET_KERNEL_CONFIG := m681_49_defconfig
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_KERNEL_VERSION := 4.9
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_KERNEL_IMAGE_NAME := kernel

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6755
# A LineageOS recovery image does not fit the 16 MiB recovery partition; the
# vendor image would also pull it in, so no recovery is built.
TARGET_NO_RECOVERY := true
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_CHARGER_SHOW_PERCENTAGE := true

# Wi-Fi
# MediaTek WMT / conn_soc combo chip.
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0

# SELinux
# The Nougat-era MTK blobs violate public policy neverallows; SELinux runs
# permissive (see the kernel cmdline). Revisit before any enforcing build.
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Qualcomm
# Not a Qualcomm device; leaving these on pulls SurfaceFlinger into QTI wrappers.
BOARD_USES_QCOM_HARDWARE := false
TARGET_USES_QCOM_BSP := false

# Properties
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# Inherit the proprietary board config (linker shims for the Nougat-era blobs).
include vendor/meizu/m681/BoardConfigVendor.mk

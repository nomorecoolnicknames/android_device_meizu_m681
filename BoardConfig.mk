DEVICE_PATH := device/meizu/m681
TARGET_MEIZU_MT675X_DEVICE := m681
BOARD_SECCOMP_POLICY := $(DEVICE_PATH)/seccomp

include device/meizu/mt6755-common/BoardConfigCommon.mk
include vendor/meizu/m681/BoardConfigVendor.mk

# Recovery partition is 16 MiB, not the 32 MiB MT6755 common default.
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216

# libmpe.sensorlistener.so needs the Nougat SensorManager symbols (moved to
# libsensor in Oreo); mtk_agpsd needs ICU 56 ucnv_* symbols. Both are 32-bit.
TARGET_LD_SHIM_LIBS += \
    /vendor/lib/libmpe.sensorlistener.so|/vendor/lib/libmtkshim_sensor.so \
    /vendor/bin/mtk_agpsd|/vendor/lib/libmtkshim_icu.so

# Assert
TARGET_DEVICE := m681
TARGET_OTA_ASSERT_DEVICE := m681,m3note
TARGET_VENDOR := meizu
# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/fstab.mt6755
# Display
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 1920
# The legacy MTK display blobs are more stable with a 32-bit SurfaceFlinger.
TARGET_32_BIT_SURFACEFLINGER := true
# MTK GuiExt/HWC configures the primary display for three buffers.
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
# The legacy MTK HWC never signals present/retire fences correctly.
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
# Wi-Fi
# MediaTek WMT / conn_soc combo chip; supplicant uses the MTK private driver commands.
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_DRIVER_OPERSTATE_PATH := /sys/class/net/wlan0/operstate
WIFI_DRIVER_STATE_CTRL_RETRIES := 8
WIFI_DRIVER_STATE_CTRL_RETRY_DELAY_US := 1000000
# Kernel
# androidboot.hardware=mt6755 is required to mount /system and select
# init.mt6755.rc; clk_ignore_unused keeps the MTK clock gates enabled.
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.selinux=permissive androidboot.hardware=mt6755 androidboot.usb.config=adb buildvariant=userdebug clk_ignore_unused
ifneq ($(strip $(M681_KERNEL_CMDLINE_EXTRA)),)
BOARD_KERNEL_CMDLINE += $(strip $(M681_KERNEL_CMDLINE_EXTRA))
endif
# Treble
# The 3.18 tree's libgui depends on libsensor, which is not vendor_available,
# so BOARD_VNDK_VERSION cannot be set.

# /vendor is the stock custom partition (p3, 512 MiB). VNDK enforcement
# stays off: PRODUCT_FULL_TREBLE_OVERRIDE is false and the shipping API is 25.
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912

# Partitions
# A-only, no dynamic partitions.
AB_OTA_UPDATER := false

# Properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# SELinux
# Default policy version 30: version 29 cannot hold the ioctl extended
# permission rules.

# Platform policy goes in BOARD_PLAT_SEPOLICY_DIRS, vendor policy in
# BOARD_SEPOLICY_DIRS; both live in the device tree.
BOARD_PLAT_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/plat
BOARD_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy \
    $(DEVICE_PATH)/sepolicy/vendor

# Kernel
BOARD_KERNEL_BASE := 0x40078000
BOARD_MKBOOTIMG_ARGS := --board 1480869018 --ramdisk_offset 0x04f88000 --second_offset 0x00e88000 --tags_offset 0x03f88000
BOARD_RAMDISK_OFFSET := 0x04f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_TAGS_OFFSET := 0x03f88000

# Kernel source build of the 3.18 tree, used with M681_SFOS_BUILD=1.
ifeq ($(M681_SFOS_BUILD),1)
ifeq ($(strip $(M681_KERNEL_SOURCE_OVERRIDE)$(M681_M6GRAFT_KERNEL_SOURCE)),)
$(error Set M681_KERNEL_SOURCE_OVERRIDE or M681_M6GRAFT_KERNEL_SOURCE to the M681 m6-graft 3.18.140 source)
endif
endif
TARGET_NO_KERNEL := false
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := $(if $(M681_KERNEL_SOURCE_OVERRIDE),$(M681_KERNEL_SOURCE_OVERRIDE),$(M681_M6GRAFT_KERNEL_SOURCE))
TARGET_KERNEL_CONFIG := $(if $(M681_KERNEL_CONFIG_OVERRIDE),$(M681_KERNEL_CONFIG_OVERRIDE),m681_defconfig)
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

# Assert
TARGET_OTA_ASSERT_DEVICE := m681,m3note
BOARD_NAME := m681

# Properties
TARGET_SYSTEM_PROP := device/meizu/m681/system.prop

# Prebuilt kernel by default; kernel built from source with M681_SFOS_BUILD=1.
ifneq ($(M681_SFOS_BUILD),1)
TARGET_NO_KERNEL := false
TARGET_KERNEL_SOURCE := kernel/meizu/meizu_m6/kernel-3.18
TARGET_KERNEL_CONFIG :=
TARGET_PREBUILT_KERNEL := device/meizu/m681/prebuilt-kernel/Image.gz-dtb
BOARD_KERNEL_IMAGE_NAME := kernel
PRODUCT_COPY_FILES += \
    device/meizu/m681/prebuilt-kernel/Image.gz-dtb:kernel
else
# SFOS build: kernel built from source with the SFOS defconfig.
TARGET_NO_KERNEL := false
TARGET_KERNEL_SOURCE := $(if $(M681_KERNEL_SOURCE_OVERRIDE),$(M681_KERNEL_SOURCE_OVERRIDE),$(M681_M6GRAFT_KERNEL_SOURCE))
TARGET_KERNEL_CONFIG := $(if $(M681_KERNEL_CONFIG_OVERRIDE),$(M681_KERNEL_CONFIG_OVERRIDE),m681_sfos_defconfig)
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
endif

# RIL
# Use the MTK HIDL RIL wrapper (vendor/mediatek/ril): the stock mtkrild stack
# cannot publish IRadio. MTK's ril.h has a larger RIL_Env than AOSP's, and
# mtk-ril.so reads the extra slots, so its header must come first.
TARGET_SPECIFIC_HEADER_PATH := vendor/mediatek/include
BOARD_PROVIDES_RILD := true
BOARD_PROVIDES_LIBRIL := true

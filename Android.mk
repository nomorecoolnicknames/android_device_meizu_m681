LOCAL_PATH:= $(call my-dir)

ifneq ($(filter m681, $(TARGET_DEVICE)),)

# first-makefiles-under stops the module finder here, so the nvram and
# wpa_supplicant_8_lib makefiles must be included explicitly.
# vendor/mediatek/ril provides the MTK libril and rild; BOARD_PROVIDES_LIBRIL
# only disables the AOSP ones, and reference-ril still needs a libril.
include $(call first-makefiles-under,$(LOCAL_PATH))
include vendor/mediatek/ril/Android.mk

endif

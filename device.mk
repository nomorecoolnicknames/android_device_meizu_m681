#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/meizu/m681

# Soong namespaces
# Pairs with the soong_namespace in Android.bp: modules of a namespace reach
# Make only for products that list it here.
PRODUCT_SOONG_NAMESPACES += \
    device/meizu/m681 \
    vendor/meizu/m681

# AAPT
# 1080x1920 display, density 480 (xxhdpi).
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Fstab
# First-stage init mounts the first_stage_mount entries from the boot ramdisk,
# so the fstab is installed there as well as in /vendor/etc.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6755 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6755

# VINTF
# Enforced through PRODUCT_FULL_TREBLE. manifest.xml lists only the HALs
# installed here; HIDL services with their own fragment are merged by the build.
DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml

# Wi-Fi
# wpa_supplicant.conf is not a build module; the device tree ships the file.
PRODUCT_PACKAGES += \
    libwpa_client \
    wpa_supplicant \
    hostapd

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant.conf

# Nothing else in the image defines the wpa_supplicant service.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init/init.m681.wifi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.m681.wifi.rc

# HIDL
# AOSP passthrough implementations and binderized services in /vendor, each
# wrapping an MT6755 blob. Not included: bluetooth@1.0 (no 64-bit
# libbt-vendor.so in the blob set), biometrics.fingerprint (see manifest.xml)
# and ir (no IR blaster).
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.renderscript@1.0-impl \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.3-service.clearkey \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service \
    android.hardware.wifi@1.0-service \
    libwifi-hal-mt66xx \
    wificond

# Vendor compatibility libraries
# Libraries the Nougat-era blobs need that a Treble vendor namespace cannot
# load from /system:
#   libgui_mt6755fwd        - /vendor/lib{,64}/libgui.so, forwards to libgui_vendor
#                             (libgui is VNDK-private).
#   libcamera_client_vendor - /vendor/lib{,64}/libcamera_client.so with the legacy
#                             symbols libsource.so imports.
#   libstdc++.vendor        - needed by many blobs.
#   libtinyxml, libalsautils - audio.primary / audio.usb.
# None of these is a VNDK or LLNDK library.
PRODUCT_PACKAGES += \
    libgui_mt6755fwd \
    libcamera_client_vendor \
    libstdc++.vendor \
    libtinyxml \
    libalsautils

# libtinycompress needs the kernel headers, hence TARGET_KERNEL_SOURCE in
# BoardConfig.mk.
PRODUCT_PACKAGES += \
    libtinycompress

# Permissions
# Camera and microphone features are not declared: both are not working yet.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Proprietary files
# inherit-product (not -if-exists): a full Treble build without the blobs
# would produce a vendor image with HAL services and nothing to wrap.
$(call inherit-product, vendor/meizu/m681/m681-vendor-blobs.mk)

# Shims for the same blob set; the linker wiring is in BoardConfigVendor.mk.
$(call inherit-product, vendor/meizu/m681/m681-vendor-shims.mk)

PRODUCT_PACKAGES += \
    m681_vendor_symlinks

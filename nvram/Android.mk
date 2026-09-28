LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := m681_nvram_wifi_repair
LOCAL_SRC_FILES := m681_nvram_wifi_repair.c \
                   m681_abi_guard.c
# m681_abi_guard.c holds compile-time ABI checks for the patched audio.h.
LOCAL_HEADER_LIBRARIES := libhardware_headers
LOCAL_SHARED_LIBRARIES := libcutils liblog
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

# Bundle Widevine DRM
WIDEVINE_PATH := $(dir $(LOCAL_PATH))proprietary/widevine

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/widevine,$(TARGET_COPY_OUT_VENDOR))

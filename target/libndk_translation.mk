# Bundle Houdini as ARM on x86 native bridge
WITH_NATIVE_BRIDGE := true
NDK_TRANSLATION_PREINSTALL := true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.dalvik.vm.isa.arm=x86 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.enable.native.bridge.exec=1

PRODUCT_PROPERTY_OVERRIDES += ro.dalvik.vm.native.bridge=libndk_translation.so

PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
    ro.dalvik.vm.native.bridge=libndk_translation.so

HOUDINI_PATH := $(dir $(LOCAL_PATH))proprietary/libndk_translation

ifeq ($(patsubst %x86_64,,$(lastword $(TARGET_PRODUCT))),)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation,$(TARGET_COPY_OUT_SYSTEM)) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/etc/binfmt_misc,$(TARGET_COPY_OUT_SYSTEM)/etc/binfmt_misc) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/etc/init,$(TARGET_COPY_OUT_SYSTEM)/etc/init) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/bin/arm,$(TARGET_COPY_OUT_SYSTEM)/bin/arm) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/bin/arm64,$(TARGET_COPY_OUT_SYSTEM)/bin/arm64) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/lib/arm,$(TARGET_COPY_OUT_SYSTEM)/lib/arm) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/lib64/arm64,$(TARGET_COPY_OUT_SYSTEM)/lib64/arm64) \

else ifeq ($(patsubst %x86,,$(lastword $(TARGET_PRODUCT))),)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation,$(TARGET_COPY_OUT_SYSTEM)) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/etc/binfmt_misc,$(TARGET_COPY_OUT_SYSTEM)/etc/binfmt_misc) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/etc/init,$(TARGET_COPY_OUT_SYSTEM)/etc/init) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/bin/arm,$(TARGET_COPY_OUT_SYSTEM)/bin/arm) \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/libndk_translation/lib/arm,$(TARGET_COPY_OUT_SYSTEM)/lib/arm) \

endif

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/system_ext,$(TARGET_COPY_OUT_SYSTEM)/system_ext) 

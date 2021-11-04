# Bundle Houdini as ARM on x86 native bridge
WITH_NATIVE_BRIDGE := true

PRODUCT_PRODUCT_PROPERTIES += \
    ro.dalvik.vm.isa.arm=x86 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.enable.native.bridge.exec=1

PRODUCT_PROPERTY_DEFAULT_OVERRIDE  += \
    ro.dalvik.vm.native.bridge=libndk_translation.so

LIBNDK_TRANSLATION_PATH := $(dir $(LOCAL_PATH))proprietary/libndk_translation
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH),$(TARGET_COPY_OUT_SYSTEM))

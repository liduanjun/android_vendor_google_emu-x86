# Bundle Houdini as ARM on x86 native bridge
WITH_NATIVE_BRIDGE := true

PRODUCT_PRODUCT_PROPERTIES += \
    ro.dalvik.vm.isa.arm=x86 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.enable.native.bridge.exec=1

PRODUCT_PROPERTY_DEFAULT_OVERRIDE  += \
    ro.dalvik.vm.native.bridge=libndk_translation.so

LIBNDK_TRANSLATION_PATH := $(dir $(LOCAL_PATH))proprietary/libndk_translation

# bin/*
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/bin,$(TARGET_COPY_OUT_SYSTEM)/bin)

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/bin/arm,$(TARGET_COPY_OUT_SYSTEM)/bin/arm)

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/bin/arm64,$(TARGET_COPY_OUT_SYSTEM)/bin/arm64)

# etc/*
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/etc,$(TARGET_COPY_OUT_SYSTEM)/etc)
    
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/etc/binfmt_misc,$(TARGET_COPY_OUT_SYSTEM)/etc/binfmt_misc)
    
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/etc/init,$(TARGET_COPY_OUT_SYSTEM)/etc/init)

# lib/*
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/lib,$(TARGET_COPY_OUT_SYSTEM)/lib)

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/lib/arm,$(TARGET_COPY_OUT_SYSTEM)/lib/arm)

# lib64/*
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/lib64,$(TARGET_COPY_OUT_SYSTEM)/lib64)
    
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LIBNDK_TRANSLATION_PATH)/lib64/arm64,$(TARGET_COPY_OUT_SYSTEM)/lib64/arm64)


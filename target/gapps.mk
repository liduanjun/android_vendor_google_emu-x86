GAPPS_PATH := $(dir $(LOCAL_PATH))proprietary/gapps

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/product,$(TARGET_COPY_OUT_PRODUCT))

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(dir $(LOCAL_PATH))proprietary/system_ext,$(TARGET_COPY_OUT_SYSTEM_EXT))


#~ # Legacy houdini files
#~ define addon-copy-from-system
#~ $(shell python "vendor/android-generic/copy_files.py" "vendor/android-generic/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
#~ endef

#~ define addon-copy-to-system
#~ $(shell python "vendor/android-generic/copy_files.py" "vendor/google/chromeos-x86/proprietary/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
#~ endef

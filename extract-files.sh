#!/usr/bin/env bash
set -euo pipefail

# Use consistent umask for reproducible builds
umask 022
if [ "$1" = "x86_64" ];then
	ASEMU_VERSION="x86_64"

elif [ "$1" = "x86" ];then
	ASEMU_VERSION="x86"
fi

ASEMU_SDK="30"
ASEMU_REVISION="09"
ASEMU_FILE="${ASEMU_VERSION}-$ASEMU_SDK_r$ASEMU_REVISION-linux"

ASEMU_FILENAME="$ASEMU_FILE.zip"
ASEMU_URL="https://dl.google.com/android/repository/sys-img/google_apis_playstore/$ASEMU_FILENAME"
ASEMU_SHA1="ef4661e49abeb64c173636012526e41ff6f39dc1 $ASEMU_FILENAME"

ASEMU_FILE="$PWD/vendor/google/emu-x86/$ASEMU_FILENAME"
TARGET_DIR="$PWD/vendor/google/emu-x86/proprietary"

# TODO - Download .zip file


read -rp "This script requires 'sudo' to mount the partitions in the AS-EMU recovery image. Continue? (Y/n) " choice
[[ -z "$choice" || "${choice,,}" == "y" ]]

echo "Checking AS-EMU image..."
if ! sha1sum -c <<< "$ASEMU_SHA1" 2> /dev/null; then
    if command -v curl &> /dev/null; then
        curl -fLo "$ASEMU_FILENAME" "$ASEMU_URL"
    elif command -v wget &> /dev/null; then
        wget -O "$ASEMU_FILENAME" "$ASEMU_URL"
    else
        echo "This script requires 'curl' or 'wget' to download the AS-EMU recovery image."
        echo "You can install one of them with the package manager provided by your distribution."
        echo "Alternatively, download $ASEMU_URL manually and place it in the current directory."
        exit 1
    fi

    sha1sum -c <<< "$ASEMU_SHA1"
fi

#~ temp_dir=$(mktemp -d)
temp_dir="vendor/google/emu-x86/temp"
if [ -d $temp_dir ]; then
	echo "Temp folder looks to be already setup"
else
	mkdir $temp_dir
fi

# Extract .zip
7z x $ASEMU_FILE -o$temp_dir/extracted_zip
cd "$temp_dir/extracted_zip/$ASEMU_VERSION/"

# TODO - Use p7zip to open file or use lpunpack 
# TODO - Extract first system.img
# TODO - Extract super.img
#~ mkdir vendor/google/emu-x86/temp/$ASEMU_VERSION/super
#~ out/host/linux-x86/bin/lpunpack vendor/google/emu-x86/temp/$ASEMU_VERSION/super.img vendor/google/emu-x86/temp/$ASEMU_VERSION/super

#~ or
gnome-disk-image-mounter --writable system.img
gnome-disk-image-mounter vendor.img
#~ vendor/google/emu-x86/utils/imjtool super.img extract
#~ vendor/google/emu-x86/utils/imjtool extracted/system.img extract

# TODO - From there, mount second system.img, system_ext.img, vendor.img & product.img

#~ function cleanup {
    #~ set +e
    #~ cd "$temp_dir"
    #~ mountpoint -q vendor && sudo umount vendor
    #~ mountpoint -q as_emu && sudo umount as_emu
    #~ [[ -n "${loop_dev:-}" ]] && sudo losetup -d "$loop_dev"
    #~ rm -r "$temp_dir"
#~ }
#~ trap cleanup EXIT

#~ ASEMU_EXTRACTED="$ASEMU_RECOVERY.bin"
#~ ASEMU_ANDROID_VENDOR_IMAGE="AS-EMU/opt/google/containers/android/vendor.raw.img"

#~ echo " -> Extracting recovery image"
#~ unzip -q "$ASEMU_FILE" "$ASEMU_EXTRACTED"

#~ echo " -> Mounting partitions"
#~ # Setup loop device
#~ loop_dev=$(sudo losetup -r -f --show --partscan "$ASEMU_EXTRACTED")

#~ mkdir AS-EMU
#~ sudo mount -r "${loop_dev}p3" AS-EMU
#~ mkdir vendor
#~ sudo mount -r "$ASEMU_ANDROID_VENDOR_IMAGE" vendor
TARGET_DIR="vendor/google/emu-x86/proprietary"
echo " -> Cleaning up"
sudo rm -rf vendor/google/emu-x86/proprietary/*

echo " -> Deleting old files"
rm -rf "$TARGET_DIR"
mkdir "$TARGET_DIR"
echo "$ASEMU_VERSION" > "$TARGET_DIR/version"

echo " -> Copying files"
RSYNC="sudo rsync -rt --files-from=-"

# Copy files
echo " -> Copying system"
$RSYNC "/media/$USER/_/system" "$TARGET_DIR/libndk_translation" <<EOF
bin/arm
bin/arm64
bin/ndk_translation_program_runner_binfmt_misc
bin/ndk_translation_program_runner_binfmt_misc_arm64
etc/binfmt_misc
etc/ld.config.arm.txt
etc/ld.config.arm64.txt
etc/init/ndk_translation_arm64.rc
lib/arm
lib/libndk_translation.so
lib/libndk_translation_proxy_libaaudio.so
lib/libndk_translation_proxy_libamidi.so
lib/libndk_translation_proxy_libandroid.so
lib/libndk_translation_proxy_libandroid_runtime.so
lib/libndk_translation_proxy_libbinder_ndk.so
lib/libndk_translation_proxy_libc.so
lib/libndk_translation_proxy_libcamera2ndk.so
lib/libndk_translation_proxy_libEGL.so
lib/libndk_translation_proxy_libGLESv1_CM.so
lib/libndk_translation_proxy_libGLESv2.so
lib/libndk_translation_proxy_libGLESv3.so
lib/libndk_translation_proxy_libicui18n.so
lib/libndk_translation_proxy_libicuuc.so
lib/libndk_translation_proxy_libjnigraphics.so
lib/libndk_translation_proxy_libmediandk.so
lib/libndk_translation_proxy_libnativehelper.so
lib/libndk_translation_proxy_libnativewindow.so
lib/libndk_translation_proxy_libneuralnetworks.so
lib/libndk_translation_proxy_libOpenMAXAL.so
lib/libndk_translation_proxy_libOpenSLES.so
lib/libndk_translation_proxy_libvulkan.so
lib/libndk_translation_proxy_libwebviewchromium_plat_support.so
lib64/arm64
lib64/libndk_translation.so
lib64/libndk_translation_proxy_libaaudio.so
lib64/libndk_translation_proxy_libamidi.so
lib64/libndk_translation_proxy_libandroid.so
lib64/libndk_translation_proxy_libandroid_runtime.so
lib64/libndk_translation_proxy_libbinder_ndk.so
lib64/libndk_translation_proxy_libc.so
lib64/libndk_translation_proxy_libcamera2ndk.so
lib64/libndk_translation_proxy_libEGL.so
lib64/libndk_translation_proxy_libGLESv1_CM.so
lib64/libndk_translation_proxy_libGLESv2.so
lib64/libndk_translation_proxy_libGLESv3.so
lib64/libndk_translation_proxy_libicui18n.so
lib64/libndk_translation_proxy_libicuuc.so
lib64/libndk_translation_proxy_libjnigraphics.so
lib64/libndk_translation_proxy_libmediandk.so
lib64/libndk_translation_proxy_libnativehelper.so
lib64/libndk_translation_proxy_libnativewindow.so
lib64/libndk_translation_proxy_libneuralnetworks.so
lib64/libndk_translation_proxy_libOpenMAXAL.so
lib64/libndk_translation_proxy_libOpenSLES.so
lib64/libndk_translation_proxy_libvulkan.so
lib64/libndk_translation_proxy_libwebviewchromium_plat_support.so
EOF

# Rename ndk_translation_program_runner_binfmt_misc file for simplification
echo " -> Moving: $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc"
sudo mv $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc_arm

# Replace ndk_translation_program_runner_binfmt_misc naming in /system/etc/binfmt_misc
sudo find $TARGET_DIR/libndk_translation/etc/binfmt_misc -type f -name "arm_*" -exec sed -i 's/ndk_translation_program_runner_binfmt_misc/ndk_translation_program_runner_binfmt_misc_arm/g' {} +  

# Widevine DRM
echo " -> Copying widevine"
$RSYNC "/media/$USER/vendor/" "$TARGET_DIR/widevine" <<EOF
bin/hw/android.hardware.drm@1.3-service.widevine
etc/init/android.hardware.drm@1.3-service.widevine.rc
lib/mediadrm/libwvdrmengine.so
lib64/mediadrm/libwvdrmengine.so
lib64/libwvhidl.so
EOF

#~ # Gapps
#~ echo " -> Copying product"
#~ $RSYNC "/media/$USER/product/" "$TARGET_DIR/product" <<EOF
#~ app
#~ priv-app
#~ etc/default-permissions
#~ etc/permissions
#~ etc/sysconfig
#~ framework
#~ overlay
#~ media
#~ lib64
#~ EOF

#~ echo " -> Copying system_ext"
#~ $RSYNC "/media/$USER/system_ext/" "$TARGET_DIR/system_ext" <<EOF
#~ app
#~ bin
#~ etc
#~ priv-app
#~ framework
#~ lib64
#~ EOF

# Normalize file modification times
#~ touch -hr "temp/super.img" "$TARGET_DIR"{/*,}
#~ mv $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc_arm
# We need to chown all files so the build system can see them.
sudo chown -R $USER $TARGET_DIR

# Then we normalize the files
echo " -> Settting normalized time for widevine"
sudo touch -hr "vendor/google/emu-x86/temp/extracted/vendor.img" "$TARGET_DIR/widevine"{/*,}
#~ echo " -> Settting normalized time for product"
#~ sudo touch -hr "vendor/google/emu-x86/temp/extracted/product.img" "$TARGET_DIR/product"{/*,}
#~ echo " -> Settting normalized time for system_ext"
#~ sudo touch -hr "vendor/google/emu-x86/temp/extracted/system_ext.img" "$TARGET_DIR/system_ext"{/*,}
echo " -> Settting normalized time for libndk_translation"
sudo touch -hr "vendor/google/emu-x86/temp/extracted_zip/system.img" "$TARGET_DIR/libndk_translation"{/*,}

echo "Done"

# TODO - Unmount all when done and cleanup

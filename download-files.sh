#!/usr/bin/env bash
set -euo pipefail
rompath=$(pwd)
dl_vendor_path="$rompath"
# Use consistent umask for reproducible builds
umask 022
if [ "$1" = "x86_64" ];then
	ASEMU_VERSION="x86_64"

elif [ "$1" = "x86" ];then
	ASEMU_VERSION="x86"
fi

temp_dir="$dl_vendor_path"

ASEMU_SDK="30"
ASEMU_REVISION="09"
ASEMU_FILE="${ASEMU_VERSION}-${ASEMU_SDK}_r${ASEMU_REVISION}-linux"
echo $ASEMU_FILE
ASEMU_FILENAME="$ASEMU_FILE.zip"
ASEMU_URL="https://dl.google.com/android/repository/sys-img/google_apis_playstore/$ASEMU_FILENAME"

ASEMU_FILE_PATH="$temp_dir/$ASEMU_FILENAME"
echo $ASEMU_FILE
ASEMU_SHA1="ef4661e49abeb64c173636012526e41ff6f39dc1 $ASEMU_FILE_PATH"
TARGET_DIR="$dl_vendor_path/proprietary"
echo $TARGET_DIR

# TODO - Download .zip file


read -rp "This script requires 'sudo' to mount the partitions in the AS-EMU recovery image. Continue? (Y/n) " choice
[[ -z "$choice" || "${choice,,}" == "y" ]]

echo "Checking AS-EMU image..."
if ! sha1sum -c <<< "$ASEMU_SHA1" 2> /dev/null; then
    if command -v curl &> /dev/null; then
        curl -fLo "$temp_dir/$ASEMU_FILENAME" "$ASEMU_URL"
    elif command -v wget &> /dev/null; then
        wget -O "$temp_dir/$ASEMU_FILENAME" "$ASEMU_URL"
    else
        echo "This script requires 'curl' or 'wget' to download the AS-EMU recovery image."
        echo "You can install one of them with the package manager provided by your distribution."
        echo "Alternatively, download $ASEMU_URL manually and place it in the current directory."
        exit 1
    fi

    sha1sum -c <<< "$ASEMU_SHA1"
fi


#~ temp_dir=$(mktemp -d)

#~ cd $dl_vendor_path/temp

# Extract .zip
echo "7z x $ASEMU_FILE_PATH -o$temp_dir/extracted"
7z x $ASEMU_FILE_PATH -o$temp_dir/extracted
# TODO - Use p7zip to open file or use lpunpack 
# TODO - Extract first system.img


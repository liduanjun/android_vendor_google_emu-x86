#!/usr/bin/env bash
set -euo pipefail
rompath=$(pwd)
dl_vendor_path="$rompath"
# Use consistent umask for reproducible builds
umask 022
if [ "$1" = "x86_64" ];then
	ASEMU_SHA1SUM="f5b2daa09b48de21a3acbbbe1c6b6c55c0cafe21"
	ASEMU_FILE="x86_64-31_r08"
	ASEMU_REPO="google_apis_playstore"

elif [ "$1" = "x86" ];then
	ASEMU_SHA1SUM="80f1f8f13e4c3503f4ffb19e2db6e724588f5871"
	ASEMU_FILE="x86-31_r03"
	ASEMU_REPO="google-tv"
fi

temp_dir="$dl_vendor_path"

echo $ASEMU_FILE
ASEMU_FILENAME="$ASEMU_FILE.zip"
ASEMU_URL="https://dl.google.com/android/repository/sys-img/${ASEMU_REPO}/$ASEMU_FILENAME"

ASEMU_FILE_PATH="$temp_dir/$ASEMU_FILENAME"
echo $ASEMU_FILE
ASEMU_SHA1="$ASEMU_SHA1SUM $ASEMU_FILE_PATH"
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
#echo "7z x $ASEMU_FILE_PATH -o$temp_dir/extracted"
#7z x $ASEMU_FILE_PATH -o$temp_dir/extracted
# TODO - Use p7zip to open file or use lpunpack 
# TODO - Extract first system.img


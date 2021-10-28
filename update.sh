#!/bin/bash
# Author:       sickcodes
# Contact:      https://twitter.com/sickcodes
# Repo:         https://github.com/sickcodes/Droid-NDK-Extractor
# Copyright:    sickcodes (C) 2021
# License:      GPLv3+

#setup colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
purple=`tput setaf 5`
teal=`tput setaf 6`
light=`tput setaf 7`
dark=`tput setaf 8`
ltred=`tput setaf 9`
ltgreen=`tput setaf 10`
ltyellow=`tput setaf 11`
ltblue=`tput setaf 12`
ltpurple=`tput setaf 13`
CL_CYN=`tput setaf 12`
CL_RST=`tput sgr0`
reset=`tput sgr0`
current_project=""
previous_project=""
conflict=""
conflict_list=""
goodpatch=""
project_revision=""

echo -e ${reset}""${reset}
echo -e ${teal}"This script requires the following dependencies: binwalk, curl/wget, 7z"${reset}
echo -e ${reset}""${reset} 

rompath=$(pwd)
vendor_path="$rompath/vendor/google/emu-x86"
TARGET_DIR="$rompath/vendor/google/emu-x86/proprietary"

ARCH="${1}"
ARCH="${ARCH:="x86_64"}"

#~ temp_dir=$(mktemp -d)
temp_dir="$vendor_path/temp"
if [ -d $TARGET_DIR ]; then
	echo -e ${reset}""${reset}
	echo -e ${ltgreen}"proprietary folder looks to be already setup"${reset}
	echo -e ${reset}""${reset}
else
	echo -e ${reset}""${reset}
	echo -e ${ltgreen}"Setting up proprietary folder"${reset}
	echo -e ${reset}""${reset}
	mkdir $TARGET_DIR
fi
if [ -d $temp_dir ]; then
	echo -e ${reset}""${reset}
	echo -e ${ltgreen}"Temp folder looks to be already setup"${reset}
	echo -e ${reset}""${reset}
else
	echo -e ${reset}""${reset}
	echo -e ${ltgreen}"Setting up temp folder"${reset}
	echo -e ${reset}""${reset}
	mkdir $vendor_path/temp
fi
cd $vendor_path/temp

echo -e ${reset}""${reset}
echo -e ${ltblue}"Chercking Downloaded Files"${reset}
echo -e ${reset}""${reset}
yes | ./../download-files.sh "${ARCH}"
echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting images"${reset}
echo -e ${reset}""${reset}
yes | unzip "${ARCH}-*-linux.zip"


echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting system.img"${reset}
echo -e ${reset}""${reset}
yes | 7z e x86_64/system.img

binwalk -e \
    --depth 1 \
    --count 1 \
    -y 'filesystem' \
    super.img # only search for filesystem signatures

# 1048576       0x100000        \
# Linux EXT filesystem, blocks count: 234701, \
# image size: 240333824, rev 1.0, ext2 filesystem data, \
# UUID=31e7cd0f-5577-515b-bea5-c836952b952b, volume name "/"

mkdir extracted
cd extracted
echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting super.img"${reset}
echo -e ${reset}""${reset}
yes | 7z x ../_super.img.extracted/100000.ext
echo -e ${reset}""${reset}
echo -e ${ltblue}"Finding needed files in system.img"${reset}
echo -e ${reset}""${reset}
#~ find system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' \) | tar -cf native-bridge.tar -T -
find system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' \) | tar -cf native-bridge.tar -T -

stat native-bridge.tar

#~ echo "${PWD}/native-bridge.tar"
echo -e ${reset}""${reset}
echo -e ${ltblue}"${PWD}/native-bridge.tar"${reset}
echo -e ${reset}""${reset}

echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting vendor.img"${reset}
echo -e ${reset}""${reset}

cd vendor 
echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting vendor.img"${reset}
echo -e ${reset}""${reset}
yes | 7z x ../x86_64/vendor.img
cd ..
echo -e ${reset}""${reset}
echo -e ${ltblue}"Finding needed files in vendor.img"${reset}
echo -e ${reset}""${reset}
find vendor \( -name 'android.hardware.drm@1.3-service.widevine*' -o -name '*libwvdrmengine*' -o -name 'libwvhidl*' \) | tar -cf widevine.tar -T -

stat widevine.tar

#~ echo "${PWD}/widevine.tar"
echo -e ${reset}""${reset}
echo -e ${ltblue}"${PWD}/widevine.tar"${reset}
echo -e ${reset}""${reset}
rm -rf ${TARGET_DIR}/*.tar
cp native-bridge.tar ${TARGET_DIR}
cp widevine.tar ${TARGET_DIR}

cd ${TARGET_DIR}
echo -e ${reset}""${reset}
echo -e ${ltyellow}"placing system files"${reset}
echo -e ${reset}""${reset}
tar --verbose -xf native-bridge.tar
echo -e ${reset}""${reset}
echo -e ${ltyellow}"placing vendor files"${reset}
echo -e ${reset}""${reset}
tar --verbose -xf widevine.tar
echo -e ${reset}""${reset}
echo -e ${ltyellow}"Starting to clean up"${reset}
echo -e ${reset}""${reset}
rm -rf libndk_translation widevine
echo -e ${reset}""${reset}
echo -e ${ltyellow}"making libndk_translation folder"${reset}
echo -e ${reset}""${reset}
mv system libndk_translation
echo -e ${reset}""${reset}
echo -e ${ltyellow}"making widevine folder"${reset}
echo -e ${reset}""${reset}
mv vendor widevine
echo -e ${reset}""${reset}
echo -e ${ltyellow}"Creating Android.bp for widevine"${reset}
echo -e ${reset}""${reset}
cp -r $vendor_path/templates/widevine/ ${TARGET_DIR}/
mv ${TARGET_DIR}/widevine/Android.bp.template ${TARGET_DIR}/widevine/Android.bp

echo -e ${reset}""${reset}
echo -e ${ltyellow}"Cleaning up a bit more"${reset}
echo -e ${reset}""${reset}
rm -rf $vendor_path/temp/*.img $vendor_path/temp/_super.img.extracted $vendor_path/temp/extracted $vendor_path/temp/x86_64 
cd $rompath
echo -e ${reset}""${reset}
echo -e ${ltgreen}"All Done! Files can be found in ${TARGET_DIR}"${reset}
echo -e ${reset}""${reset}
 

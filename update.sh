#!/bin/bash
# Author:       sickcodes
# Contact:      https://twitter.com/sickcodes
# Repo:         https://github.com/sickcodes/Droid-NDK-Extractor
# Copyright:    sickcodes (C) 2021
# License:      GPLv3+
#~ set -euo pipefail

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
wv_api=""

echo -e ${reset}""${reset}
echo -e ${teal}"This script requires the following dependencies: binwalk, curl/wget, 7z"${reset}
echo -e ${reset}""${reset} 

rompath=$(pwd)
vendor_path="$rompath/vendor/google/emu-x86"
TARGET_DIR="$rompath/vendor/google/emu-x86/proprietary"

ARCH="${1}"
ARCH="${ARCH:="x86_64"}"

if [ -f $rompath/build/make/core/version_defaults.mk ]; then
	if grep -q "PLATFORM_SDK_VERSION := 29" $rompath/build/make/core/version_defaults.mk; then
        wv_api="29"
    fi
    if grep -q "PLATFORM_SDK_VERSION := 30" $rompath/build/make/core/version_defaults.mk; then
        wv_api="30"
    fi
    if grep -q "PLATFORM_SDK_VERSION := 31" $rompath/build/make/core/version_defaults.mk; then
        wv_api="31"
    fi
fi

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
yes | ./../download-files.sh "${ARCH}" || return $?
if [ $ARCH = "x86_64" ]; then
    yes | ./../download-files.sh "x86" || return $?
fi
echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting images"${reset}
echo -e ${reset}""${reset}
yes | 7z x "${ARCH}-*.zip"
if [ $ARCH = "x86_64" ]; then
    yes | 7z x "x86-*.zip"
fi


echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting system.img"${reset}
echo -e ${reset}""${reset}
yes | 7z e ${ARCH}/system.img -o${ARCH}-system
if [ $ARCH = "x86_64" ]; then
    yes | 7z e x86/system.img -ox86-system
fi

binwalk -e \
    --depth 1 \
    --count 1 \
    -y 'filesystem' \
    ${ARCH}-system/super.img # only search for filesystem signatures
if [ $ARCH = "x86_64" ]; then
    binwalk -e \
    --depth 1 \
    --count 1 \
    -y 'filesystem' \
    x86-system/super.img # only search for filesystem signatures
fi

# 1048576       0x100000        \
# Linux EXT filesystem, blocks count: 234701, \
# image size: 240333824, rev 1.0, ext2 filesystem data, \
# UUID=31e7cd0f-5577-515b-bea5-c836952b952b, volume name "/"

mkdir extracted
cd extracted
echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting super.img"${reset}
echo -e ${reset}""${reset}
yes | 7z x ../${ARCH}-system/_super.img.extracted/100000.ext* -o${ARCH}
if [ $ARCH = "x86_64" ]; then
    yes | 7z x ../x86-system/_super.img.extracted/100000.ext* -ox86
fi
echo -e ${reset}""${reset}
echo -e ${ltblue}"Finding needed files in system.img"${reset}
echo -e ${reset}""${reset}
#~ find system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' \) | tar -cf native-bridge.tar -T -
find ${ARCH}/system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' \) | grep -v libalarm_jni.so | tar -cf native-bridge.tar -T -
if [ $ARCH = "x86_64" ]; then
    find x86/system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' \) | grep -v libalarm_jni.so | tar -cf native-bridge_x86.tar -T -
fi

stat native-bridge.tar
if [ $ARCH = "x86_64" ]; then
    stat native-bridge_x86.tar
fi

#~ echo "${PWD}/native-bridge.tar"
echo -e ${reset}""${reset}
echo -e ${ltblue}"${PWD}/native-bridge.tar"${reset}
if [ $ARCH = "x86_64" ]; then
    echo -e ${ltblue}"${PWD}/native-bridge_x86.tar"${reset}
fi
echo -e ${reset}""${reset}

echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting vendor.img"${reset}
echo -e ${reset}""${reset}

cd ${ARCH}/vendor
echo -e ${reset}""${reset}
echo -e ${ltblue}"Extracting vendor.img"${reset}
echo -e ${reset}""${reset}
yes | 7z x ../../../${ARCH}/vendor.img
cd ../..
if [ $ARCH = "x86_64" ]; then
    cd x86/vendor
    echo -e ${reset}""${reset}
    echo -e ${ltblue}"Extracting x86 vendor.img"${reset}
    echo -e ${reset}""${reset}
    yes | 7z x ../../../x86/vendor.img
cd ../..
fi
echo -e ${reset}""${reset}
echo -e ${ltblue}"Finding needed files in vendor.img"${reset}
echo -e ${reset}""${reset}
find ${ARCH}/vendor \( -name '*libwv*' -o -name '*widevine*' -o -name 'libprotobuf-cpp-lite*' \) | tar -cf widevine.tar -T -
if [ $ARCH = "x86_64" ]; then
    find x86/vendor \( -name '*libwv*' -o -name '*widevine*' -o -name 'libprotobuf-cpp-lite*' \) | tar -cf widevine_x86.tar -T -
fi

stat widevine.tar
if [ $ARCH = "x86_64" ]; then
    stat widevine_x86.tar
fi

#~ echo "${PWD}/widevine.tar"
echo -e ${reset}""${reset}
echo -e ${ltblue}"${PWD}/widevine.tar"${reset}
if [ $ARCH = "x86_64" ]; then
    echo -e ${ltblue}"${PWD}/widevine_x86.tar"${reset}
fi
echo -e ${reset}""${reset}
rm -rf ${TARGET_DIR}/*.tar
cp native-bridge.tar ${TARGET_DIR}
cp widevine.tar ${TARGET_DIR}
if [ $ARCH = "x86_64" ]; then
    cp native-bridge_x86.tar ${TARGET_DIR}
    cp widevine_x86.tar ${TARGET_DIR}
fi

cd ${TARGET_DIR}
echo -e ${reset}""${reset}
echo -e ${ltyellow}"placing system files"${reset}
echo -e ${reset}""${reset}
tar --verbose -xf native-bridge.tar
if [ $ARCH = "x86_64" ]; then
    tar --verbose -xf native-bridge_x86.tar
fi
echo -e ${reset}""${reset}
echo -e ${ltyellow}"placing vendor files"${reset}
echo -e ${reset}""${reset}
tar --verbose -xf widevine.tar
if [ $ARCH = "x86_64" ]; then
    tar --verbose -xf widevine_x86.tar
fi
echo -e ${reset}""${reset}
echo -e ${ltyellow}"Starting to clean up"${reset}
echo -e ${reset}""${reset}
rm -rf libndk_translation widevine
echo -e ${reset}""${reset}
echo -e ${ltyellow}"making libndk_translation folder"${reset}
echo -e ${reset}""${reset}
mv ${ARCH}/system libndk_translation
if [ $ARCH = "x86_64" ]; then
    mv x86/system/lib/ libndk_translation
	mv x86/system/bin/* libndk_translation/bin/
fi
echo -e ${reset}""${reset}
echo -e ${ltyellow}"making widevine folder"${reset}
echo -e ${reset}""${reset}
mkdir -p widevine
mv ${ARCH}/vendor widevine/vendor
rmdir ${ARCH}
rm *.tar
if [ $ARCH = "x86_64" ]; then
    mv x86/vendor/lib/ widevine/vendor
	rm -rf x86/
fi
echo -e ${reset}""${reset}
echo -e ${ltyellow}"Creating Android.bp for widevine"${reset}
echo -e ${reset}""${reset}
cp -r $vendor_path/templates/widevine/ ${TARGET_DIR}/
if [ -f ${TARGET_DIR}/widevine/Android.bp.$wv_api.$ARCH.template ]; then
    mv ${TARGET_DIR}/widevine/Android.bp.$wv_api.$ARCH.template ${TARGET_DIR}/widevine/Android.bp
else
    mv ${TARGET_DIR}/widevine/Android.bp.$wv_api.template ${TARGET_DIR}/widevine/Android.bp
fi

echo -e ${reset}""${reset}
echo -e ${ltyellow}"Cleaning up a bit more"${reset}
echo -e ${reset}""${reset}
rm -rf $vendor_path/temp/${ARCH}-system $vendor_path/temp/extracted $vendor_path/temp/${ARCH} $vendor_path/temp/*.tar
if [ $ARCH = "x86_64" ]; then
    rm -rf $vendor_path/temp/x86-system $vendor_path/temp/x86
fi
cd $rompath
echo -e ${reset}""${reset}
echo -e ${ltgreen}"All Done! Files can be found in ${TARGET_DIR}"${reset}
echo -e ${reset}""${reset}
 

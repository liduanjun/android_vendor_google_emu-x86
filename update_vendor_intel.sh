#!/usr/bin/env bash

SOURCE_DIR="$PWD/proprietary/houdini"
TARGET_DIR="$PWD/../../intel/houdini/system"

read -rp "Script to update arm translator files *_y for 64k32u and *_z for 64k64k - Use only after extract-files.sh - Continue? (Y/n) " choice
[[ -z "$choice" || "${choice,,}" == "y" ]]

echo "Updating vendor/intel files..."

# Native bridge (Houdini)

echo " -> Deleting old arm files"
rm -r "$TARGET_DIR/lib/arm"
echo " -> Copying arm files"
rsync -rt "$SOURCE_DIR/lib/arm/" "$TARGET_DIR/lib/arm"
cp "$SOURCE_DIR/lib/libhoudini.so" "$TARGET_DIR/lib/libhoudini_y.so"
cp "$SOURCE_DIR/bin/houdini" "$TARGET_DIR/vendor/bin/houdini_y"

echo " -> Deleting old arm64 files"
rm -r "$TARGET_DIR/lib64/arm64"

echo " -> Copying arm64 files"
rsync -rt "$SOURCE_DIR/lib64/arm64/" "$TARGET_DIR/lib64/arm64"
cp "$SOURCE_DIR/lib64/libhoudini.so" "$TARGET_DIR/lib64/libhoudini_z.so"
cp "$SOURCE_DIR/bin/houdini64" "$TARGET_DIR/vendor/bin/houdini_z"

echo "Done"

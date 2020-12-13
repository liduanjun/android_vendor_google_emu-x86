# android_vendor_google_emu-x86
This project provides scripts to extract (proprietary) files
from the Android emulator images, for use in x86-based Android 
installations.

These files (mainly binaries) complement what is available in AOSP,
and provide the following functionality:

 - **Widevine:** DRM system from Google used in certain media streaming
   apps like Netflix. ChromeOS contains a HIDL HAL implementation that provides
   security level L3 (software decoding).
 - **libndk_translation:** ARM on x86 native bridge by Google. Allows running apps built
   only for ARM platforms on x86-based devices.

Currently, this project extracts files suitable for Android 11.0 (R).

## Usage

## Extracting from Google Emulator images
This repository contains build scripts for the following two flashable ZIPs:

  - Widevine (DRM used in some streaming apps)
  - libndk_translation (used to run ARM apps on x86)

There are no pre-built ZIP packages provided by this project.
However, building the ZIP should always produce the same file.
Therefore its integrity can be verified using the checksums available in the
[release section](https://gitlab.com/android-generic/android_vendor_google_emu-x86).

### Requirements
- Linux (e.g. Debian, Ubuntu, ...)
- curl or wget, rsync, zip, unzip
  - Debian/Ubuntu: `sudo apt install curl rsync zip unzip` (usually installed by default)

### Building
1. Download the **Source code** as `.tar.gz` from the
   [release section](https://gitlab.com/android-generic/android_vendor_google_emu-x86)
   and unpack it.

2. Open a terminal and run:
   ```
   $ ./download-files.sh x86_64
   ```
   or, for 32bit
   ```
   $ ./download-files.sh x86
   ```

   Then follow these instructions.
   This will download a emu image and extract the needed files from it.
   
3. From there, you need to build the lpunpack util and use that to extract the system.img
   '''
   . build/envsetup.sh
	lunch android_${ASEMU_VERSION}-userdebug
	mm lpunpack
	mkdir vendor/google/emu-x86/temp/extracted/x86_64/system
	out/host/linux-x86/bin/lpunpack vendor/google/emu-x86/temp/extracted/x86_64/system.img vendor/google/emu-x86/temp/extracted/x86_64/system
	'''

4. Then you can mount the images from GUI, or from terminal
	'''
	gnome-disk-image-mounter vendor/google/emu-x86/temp/extracted/x86_64/system/system.img
	gnome-disk-image-mounter vendor/google/emu-x86/temp/extracted/x86_64/system/product.img
	gnome-disk-image-mounter vendor/google/emu-x86/temp/extracted/x86_64/system/system_ext.img
	gnome-disk-image-mounter vendor/google/emu-x86/temp/extracted/x86_64/system/vendor.img
	'''

5. Now we can pull the files we need from the image with a script
	For 64bit:
	'''
	./ext_emu_x86_64.sh
	'''
	or for 32bit: (currently not supported)
	'''
	./ext_emu_x86.sh
	'''

### Make files
`board` and `target` contain make files that can be used to bundle the
proprietary files in an Android build.

  - **libndk_translaton:**
    `board/native_bridge_arm_on_x86.mk` must be included from `BoardConfig.mk`
    even if a native bridge should be optionally installed. It configures the
    build system to build additional code needed to run ARM apps.

    - `BoardConfig.mk`: Always required.

        ```make
        -include vendor/google/emu-x86/board/native_bridge_arm_on_x86.mk
        ```

    - `device.mk`: Do not advertise support for ARM ABI by default (for use when
        libndk_translation is not bundled):

        ```make
        $(call inherit-product-if-exists, vendor/google/emu-x86/target/native_bridge_arm_on_x86.mk)
        ```

        Optional: Bundle libndk_translation directly with the Android build:

        ```make
        $(call inherit-product-if-exists, vendor/google/emu-x86/target/libndk_translation.mk)
        ```

  - **Widevine:** `device.mk`: Bundle Widevine directly with the Android build.

    ```make
    $(call inherit-product-if-exists, vendor/google/emu-x86/target/widevine.mk)
    ```

## License
Please see [`LICENSE`](/LICENSE).

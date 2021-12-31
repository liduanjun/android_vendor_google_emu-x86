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

Currently, this project extracts files suitable for Android 10.0 (Q), 11.0 (R) & 12.0 (S).

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
  - Debian/Ubuntu: `sudo apt install curl rsync zip unzip binwalk` (usually installed by default)
    Also need to install `7z` from [7-zip.org](https://www.7-zip.org/download.html)

### Building
1. Download the **Source code** as `.tar.gz` from the
   [release section](https://gitlab.com/android-generic/android_vendor_google_emu-x86)
   and unpack it.

2. Open a terminal and cd into your project folder, then run:

   `git clone https://gitlab.com/android-generic/android_vendor_google_emu-x86 vendor/google/emu-x86`
   
3. Then we need to run the update script
   
   `$ . vendor/google/emu-x86/update.sh x86_64`
   
   This will download the NDK Emulator image and extract the needed files from it for libndk & widevine.
   

### Make files
`board` and `target` contain make files that can be used to bundle the
proprietary files in an Android build.

  - **libndk_translaton:**
    `board/native_bridge_arm_on_x86.mk` must be included from `BoardConfig.mk`
    even if a native bridge should be optionally installed. It configures the
    build system to build additional code needed to run ARM apps.

    - `BoardConfig.mk`: Always required.

        `-include vendor/google/emu-x86/board/native_bridge_arm_on_x86.mk`

    - `device.mk`: Do not advertise support for ARM ABI by default (for use when
        libndk_translation is not bundled):

        `$(call inherit-product-if-exists, vendor/google/emu-x86/target/native_bridge_arm_on_x86.mk)`

        Optional: Bundle libndk_translation directly with the Android build:

        `$(call inherit-product-if-exists, vendor/google/emu-x86/target/libndk_translation.mk)`

  - **Widevine:** `device.mk`: Bundle Widevine directly with the Android build.

    `$(call inherit-product-if-exists, vendor/google/emu-x86/target/widevine.mk)`

## License
Please see [`LICENSE`](/LICENSE).

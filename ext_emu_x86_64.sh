TARGET_DIR="vendor/google/emu-x86/proprietary"
VENDOR_DIR="vendor/google/emu-x86"
echo " -> Cleaning up"
sudo rm -rf $TARGET_DIR/libndk_ranslation/*
sudo rm -rf $TARGET_DIR/product/*
sudo rm -rf $TARGET_DIR/system_ext/*
echo " -> Copying files"
RSYNC="sudo rsync -rt --files-from=-"

# Copy libndk_translation files
echo " -> Copying libndk_translation files"
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

# Override a couple config files
sudo cp -rvf $VENDOR_DIR/overrides/system/etc $TARGET_DIR/libndk_translation

# Rename ndk_translation_program_runner_binfmt_misc file for simplification
echo " -> Moving: $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc"
sudo mv $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc $TARGET_DIR/libndk_translation/bin/ndk_translation_program_runner_binfmt_misc_arm

# Replace ndk_translation_program_runner_binfmt_misc naming in /system/etc/binfmt_misc
sudo find $TARGET_DIR/libndk_translation/etc/binfmt_misc -type f -name "arm_*" -exec sed -i 's/ndk_translation_program_runner_binfmt_misc/ndk_translation_program_runner_binfmt_misc_arm/g' {} +  

#~ # Widevine DRM
echo " -> Copying widevine"
$RSYNC "/media/$USER/vendor/" "$TARGET_DIR/widevine" <<EOF
bin/hw/android.hardware.drm@1.3-service.widevine
etc/init/android.hardware.drm@1.3-service.widevine.rc
lib/mediadrm/libwvdrmengine.so
lib64/mediadrm/libwvdrmengine.so
lib64/libwvhidl.so
EOF

# Gapps
echo " -> Copying product apps"
$RSYNC "/media/$USER/product/" "g_product" <<EOF
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
priv-app/WellbeingPrebuilt/oat/x86_64/WellbeingPrebuilt.vdex
priv-app/WellbeingPrebuilt/oat/x86_64/WellbeingPrebuilt.odex
priv-app/Velvet/Velvet.apk
priv-app/Velvet/oat/x86_64/Velvet.vdex
priv-app/Velvet/oat/x86_64/Velvet.odex
priv-app/Velvet/oat/x86/Velvet.vdex
priv-app/Velvet/oat/x86/Velvet.odex
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/PrebuiltGmsCore/oat/x86_64/PrebuiltGmsCore.vdex
priv-app/PrebuiltGmsCore/oat/x86_64/PrebuiltGmsCore.odex
priv-app/PrebuiltGmsCore/oat/x86/PrebuiltGmsCore.vdex
priv-app/PrebuiltGmsCore/oat/x86/PrebuiltGmsCore.odex
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_MeasurementDynamite.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_MapsDynamite.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_GoogleCertificates.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_DynamiteModulesC.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_DynamiteModulesA.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_DynamiteLoader.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_CronetDynamite.apk
priv-app/PrebuiltGmsCore/app_chimera/m/PrebuiltGmsCore_AdsDynamite.apk
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_MeasurementDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_MeasurementDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_MapsDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_MapsDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_GoogleCertificates.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_GoogleCertificates.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_DynamiteModulesC.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_DynamiteModulesC.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_DynamiteModulesA.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_DynamiteModulesA.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_DynamiteLoader.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_DynamiteLoader.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_CronetDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_CronetDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_AdsDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86_64/PrebuiltGmsCore_AdsDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_MeasurementDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_MeasurementDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_MapsDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_AdsDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_AdsDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_CronetDynamite.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_CronetDynamite.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_DynamiteLoader.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_DynamiteLoader.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_DynamiteModulesA.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_DynamiteModulesA.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_DynamiteModulesC.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_DynamiteModulesC.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_GoogleCertificates.odex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_GoogleCertificates.vdex
priv-app/PrebuiltGmsCore/app_chimera/m/oat/x86/PrebuiltGmsCore_MapsDynamite.odex
priv-app/Phonesky/Phonesky.apk
priv-app/Phonesky/oat/x86_64/Phonesky.odex
priv-app/Phonesky/oat/x86_64/Phonesky.vdex
priv-app/PartnerSetupPrebuilt/PartnerSetupPrebuilt.apk
priv-app/PartnerSetupPrebuilt/oat/x86_64/PartnerSetupPrebuilt.odex
priv-app/PartnerSetupPrebuilt/oat/x86_64/PartnerSetupPrebuilt.vdex
priv-app/GoogleRestorePrebuilt/GoogleRestorePrebuilt.apk
priv-app/GoogleRestorePrebuilt/oat/x86_64/GoogleRestorePrebuilt.odex
priv-app/GoogleRestorePrebuilt/oat/x86_64/GoogleRestorePrebuilt.vdex
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/ConfigUpdater/oat/x86_64/ConfigUpdater.odex
priv-app/ConfigUpdater/oat/x86_64/ConfigUpdater.vdex
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/AndroidMigratePrebuilt/oat/x86_64/AndroidMigratePrebuilt.odex
priv-app/AndroidMigratePrebuilt/oat/x86_64/AndroidMigratePrebuilt.vdex
priv-app/AndroidAutoFullPrebuilt/AndroidAutoFullPrebuilt.apk
priv-app/AndroidAutoFullPrebuilt/oat/x86_64/AndroidAutoFullPrebuilt.odex
priv-app/AndroidAutoFullPrebuilt/oat/x86_64/AndroidAutoFullPrebuilt.vdex
app/WebViewGoogle/WebViewGoogle.apk
app/WebViewGoogle/oat/x86_64/WebViewGoogle.odex
app/WebViewGoogle/oat/x86_64/WebViewGoogle.vdex
app/WebViewGoogle/oat/x86/WebViewGoogle.odex
app/WebViewGoogle/oat/x86/WebViewGoogle.vdex
app/WallpapersBReel2018/WallpapersBReel2018.apk
app/WallpapersBReel2018/oat/x86_64/WallpapersBReel2018.odex
app/WallpapersBReel2018/oat/x86_64/WallpapersBReel2018.vdex
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleContactsSyncAdapter/oat/x86_64/GoogleContactsSyncAdapter.odex
app/GoogleContactsSyncAdapter/oat/x86_64/GoogleContactsSyncAdapter.vdex
app/PrebuiltGoogleTelemetryTvp/PrebuiltGoogleTelemetryTvp.apk
app/PrebuiltGoogleTelemetryTvp/oat/x86_64/PrebuiltGoogleTelemetryTvp.odex
app/PrebuiltGoogleTelemetryTvp/oat/x86_64/PrebuiltGoogleTelemetryTvp.vdex
app/YouTube/YouTube.apk
app/YouTube/oat/x86_64/YouTube.odex
app/YouTube/oat/x86_64/YouTube.vdex
app/YouTube/oat/x86/YouTube.odex
app/YouTube/oat/x86/YouTube.vdex
EOF

echo " -> Copying makefiles"
RD_MK="vendor/google/emu-x86/templates/Android.mk"
TEMP_APP_MK="vendor/google/emu-x86/templates/app/Android.mk"
TEMP_PRIV_APP_MK="vendor/google/emu-x86/templates/priv-app/Android.mk"
cp $RD_MK $VENDOR_DIR/g_product/Android.mk
cp $RD_MK $VENDOR_DIR/g_product/priv-app/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/WellbeingPrebuilt/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/Velvet/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/PrebuiltGmsCore/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/PrebuiltGmsCore/app_chimera/m/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/Phonesky/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/PartnerSetupPrebuilt/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/GoogleRestorePrebuilt/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/ConfigUpdater/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/AndroidMigratePrebuilt/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_product/priv-app/AndroidAutoFullPrebuilt/Android.mk
cp $RD_MK $VENDOR_DIR/g_product/app/Android.mk
cp $TEMP_APP_MK $VENDOR_DIR/g_product/app/WebViewGoogle/Android.mk
cp $TEMP_APP_MK $VENDOR_DIR/g_product/app/WallpapersBReel2018/Android.mk
cp $TEMP_APP_MK $VENDOR_DIR/g_product/app/GoogleContactsSyncAdapter/Android.mk
cp $TEMP_APP_MK $VENDOR_DIR/g_product/app/PrebuiltGoogleTelemetryTvp/Android.mk
cp $TEMP_APP_MK $VENDOR_DIR/g_product/app/YouTube/Android.mk

echo " -> Copying product misc"
$RSYNC "/media/$USER/product/" "$TARGET_DIR/product" <<EOF
etc/permissions/android.hardware.telephony.euicc.xml
etc/permissions/android.software.verified_boot.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/privapp-permissions-goldfish.xml
etc/permissions/privapp-permissions-google-p.xml
etc/permissions/privapp-permissions-sdk-google.xml
etc/permissions/split-permissions-google.xml
etc/sysconfig/google.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/wellbeing.xml
lib64/libwallpapers-breel-2018-jni.so
EOF

echo " -> Copying system_ext apps"
$RSYNC "/media/$USER/system_ext/" "g_system_ext" <<EOF
priv-app/MultiDisplayProvider/MultiDisplayProvider.apk
priv-app/MultiDisplayProvider/oat/x86_64/MultiDisplayProvider.odex
priv-app/MultiDisplayProvider/oat/x86_64/MultiDisplayProvider.vdex
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/GoogleServicesFramework/oat/x86_64/GoogleServicesFramework.odex
priv-app/GoogleServicesFramework/oat/x86_64/GoogleServicesFramework.vdex
priv-app/GoogleOneTimeInitializer/GoogleOneTimeInitializer.apk
priv-app/GoogleOneTimeInitializer/oat/x86_64/GoogleOneTimeInitializer.odex
priv-app/GoogleOneTimeInitializer/oat/x86_64/GoogleOneTimeInitializer.vdex
EOF

echo " -> Copying moar makefiles"
RD_MK="vendor/google/emu-x86/templates/Android.mk"
TEMP_PRIV_APP_MK="vendor/google/emu-x86/templates/priv-app/Android.mk"
cp $RD_MK $VENDOR_DIR/g_system_ext/Android.mk
cp $RD_MK $VENDOR_DIR/g_system_ext/priv-app/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_system_ext/priv-app/MultiDisplayProvider/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_system_ext/priv-app/GoogleServicesFramework/Android.mk
cp $TEMP_PRIV_APP_MK $VENDOR_DIR/g_system_ext/priv-app/GoogleOneTimeInitializer/Android.mk

echo " -> Copying system_ext misc"
$RSYNC "/media/$USER/system_ext/" "$TARGET_DIR/system_ext" <<EOF
framework/androidx.window.sidecar.jar
framework/oat/x86_64/androidx.window.sidecar.odex
framework/oat/x86_64/androidx.window.sidecar.vdex
framework/oat/x86/androidx.window.sidecar.odex
framework/oat/x86/androidx.window.sidecar.vdex
etc/permissions/androidx.window.sidecar.xml
etc/permissions/com.google.android.sdksetup.xml
etc/permissions/privapp-permissions-google-se.xml
EOF

# We need to chown all files so the build system can see them.
sudo chown -R $USER $TARGET_DIR

# Then we normalize the files
echo " -> Settting normalized time for widevine"
sudo touch -hr "vendor/google/emu-x86/temp/extracted/vendor.img" "$TARGET_DIR/widevine"{/*,}
echo " -> Settting normalized time for product"
sudo touch -hr "vendor/google/emu-x86/temp/extracted/product.img" "$TARGET_DIR/product"{/*,}
sudo touch -hr "vendor/google/emu-x86/temp/extracted/product.img" "g_product"{/*,}
echo " -> Settting normalized time for system_ext"
sudo touch -hr "vendor/google/emu-x86/temp/extracted/system_ext.img" "$TARGET_DIR/system_ext"{/*,}
sudo touch -hr "vendor/google/emu-x86/temp/extracted/system_ext.img" "g_system_ext"{/*,}
echo " -> Settting normalized time for libndk_translation"
sudo touch -hr "vendor/google/emu-x86/temp/extracted/system.img" "$TARGET_DIR/libndk_translation"{/*,}

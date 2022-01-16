# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/LineageOS/android.git -b lineage-19.0 -g default,-mips,-darwin,-notdefault
git clone https://github.com/ping2109/local_manifest.git --depth 1 -b lineage-davinci .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch lineage_davinci-userdebug
export TZ=Asia/HoChiMinh #   put before last build command
export SKIP_ABI_CHECKS=true
export ALLOW_MISSING_DEPEDENCIES=true
export BUILD_HOSTNAME=ping2109
export BUILD_USERNAME=urmom
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P

# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/CherishOS/android_manifest.git -b twelve -g default,-mips,-darwin,-notdefault
git clone https://github.com/ping2109/local_manifest.git --depth 1 -b cherish-davinci .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
. build/envsetup.sh
lunch lineage_davinci-userdebug
export SKIP_ABI_CHECKS=true
export ALLOW_MISSING_DEPEDENCIES=true
export TZ=Asia/HoChiMinh #put before last build command
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P

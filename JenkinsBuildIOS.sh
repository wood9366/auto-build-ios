#!/bin/bash

PROJECT_PATH="$WORKSPACE/UnityProject"
XCODE_PATH="$WORKSPACE/xcode"

BUILD="$PROJECT_PATH/Tools/BuildScripts/BuildIOS.sh"
COPY="$PROJECT_PATH/Tools/BuildScripts/CopyToShareServer.sh"

# get git version
cd $PROJECT_PATH
GITVERSION=`git log -1 | grep commit | cut -d ' ' -f 2`

echo "Git Version: $GITVERSION"

# generate output ipa path
OUTPUT_DIR="${WORKSPACE}/builds"

if [ ! -e "$OUTPUT_DIR" ]; then
	mkdir -pv "$OUTPUT_DIR"
fi

OUTPUT_PATH="${OUTPUT_DIR}/${JOB_NAME}_${BUILD_NUMBER}_$(date +%Y%m%d_%H%M%S)_${GITVERSION}.ipa"

PROVISION_PROFILE_PATH="$PROJECT_PATH/Tools/BuildScripts/app.mobileprovision"

# build unity project and generate ipa
"$BUILD" "$PROJECT_PATH" "$XCODE_PATH" "$OUTPUT_PATH" "$PROVISION_PROFILE_PATH" "AppProductName" "AppBundleId"

# copy generate ipa to share server ios build folder
"$COPY" "$OUTPUT_PATH" "ios"

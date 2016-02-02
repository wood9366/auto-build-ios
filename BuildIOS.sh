#!/bin/bash

PROJECT_PATH="$1"
XCODE_PATH="$2"
OUTPUT_PATH="$3"
PROVISION_PROFILE_PATH="$4"
PRODUCT_NAME=${5:-'appname'}
APPID=${6:-'app.bundle.id'}

UNITYAPP="/Applications/Unity/Unity.app/Contents/MacOS/Unity"

if [ -z "$PROJECT_PATH" ]; then
	echo "Error, No project path set"
	exit 1
fi

echo "Project Path: $PROJECT_PATH"

if [ -z "$XCODE_PATH" ]; then
	echo "Error, No xcode path set"
	exit 1
fi

echo "XCode Path: $XCODE_PATH"
echo "Output Path: $OUTPUT_PATH"
echo "App ID: $APPID"
echo "Product Name: $PRODUCT_NAME"

# clean xcode project before build
if [ -e "$XCODE_PATH" ] && [ -d "$XCODE_PATH" ]; then
	rm -rf "$XCODE_PATH"
fi

# build unity, generate xcode project
$UNITYAPP -batchmode -quit -logFile -executeMethod CustomBuild.BuildIOS -projectPath "$PROJECT_PATH" -o "$XCODE_PATH" -appid "$APPID" -name "$PRODUCT_NAME"

# fix xcode project
# disable bincode
ruby "$PROJECT_PATH/Tools/BuildScripts/setup_xcodeproj.rb" "$XCODE_PATH/Unity-iPhone.xcodeproj"

# check provision profile
if [ -z "$PROVISION_PROFILE_PATH" ] || [ ! -e "$PROVISION_PROFILE_PATH" ] || [ ! -f "$PROVISION_PROFILE_PATH" ]; then
	echo "Error, no provision profile [$PROVISION_PROFILE_PATH]"
	exit 1
fi

echo "Provision Profile: $PROVISION_PROFILE_PATH"

# get provision profile uuid
PROVISION_PROFILE_UUID=`/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i "$PROVISION_PROFILE_PATH")`

if [ -z $PROVISION_PROFILE_UUID ]; then
	echo "Error, invalid provision profile, can't get UUID from provision file [$PROVISION_PROFILE_PATH]"
	exit 1
fi

# check & prepare provision profile at xcode profiles folder
XCODE_PROVISION_PROFILE_PATH="${HOME}/Library/MobileDevice/Provisioning Profiles/${PROVISION_PROFILE_UUID}.mobileprovision"

if [ ! -e "$XCODE_PROVISION_PROFILE_PATH" ] || [ ! -f "$XCODE_PROVISION_PROFILE_PATH" ]; then
	cp -f "$PROVISION_PROFILE_PATH" "$XCODE_PROVISION_PROFILE_PATH"
fi

# build xcode project with provision profile
cd $XCODE_PATH

# unlock keychain to ignore code sign error
security unlock-keychain  -p "123456" ~/Library/Keychains/login.keychain

xcodebuild -target "Unity-iPhone" clean
xcodebuild -target "Unity-iPhone" -configuration Release PROVISIONING_PROFILE=$PROVISION_PROFILE_UUID

# generate ipa with provision profile embed
APP_PATH="$XCODE_PATH/build/Release-iphoneos/${PRODUCT_NAME}.app"

xcrun -sdk iphoneos PackageApplication -v "$APP_PATH" -o "$OUTPUT_PATH" --embed "$XCODE_PROVISION_PROFILE_PATH"

# clean xcode project after build
if [ -e "$XCODE_PATH" ] && [ -d "$XCODE_PATH" ]; then
	rm -rf "$XCODE_PATH"
fi

#!/bin/bash

SRC_PATH="$1"
DST_TYPE="$2"

NETWORK_SHARE_PATH="/Volumes/NetworkShare"

if [ -z "$SRC_PATH" ]; then
	echo "Error, no copy src path"
	exit 1
fi

if [ -z "$DST_TYPE" ]; then
	echo "Error, no copy dst type"
	exit 1
fi

# copy source file to share folder
mkdir "$NETWORK_SHARE_PATH"
sudo mount_smbfs //guest@network-share-server-name/shared-folder/ "$NETWORK_SHARE_PATH"

IOS_SHARE_PATH="$NETWORK_SHARE_PATH/build/${DST_TYPE}"

if [ ! -e "$IOS_SHARE_PATH" ]; then
	mkdir -pv "$IOS_SHARE_PATH"
fi

cp -f "$SRC_PATH" "$IOS_SHARE_PATH"
sudo umount "$NETWORK_SHARE_PATH"

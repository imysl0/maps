#!/bin/sh

case "$1" in
    "-h" | "--help")
        echo "usage: ${0##*/} [PACKAGE_NAME]"
        exit
        ;;
    "")
        PACKAGE_NAME=${PWD##*/} # '##*/' removes everything before the last slash and the last slash
        ;;
    *)
        PACKAGE_NAME=${1%.xdc} # '%.xdc' removes the extension and allows PACKAGE_NAME to be given with or without extension
        ;;
esac

rm "$PACKAGE_NAME.xdc" 2> /dev/null
zip -9 --recurse-paths "$PACKAGE_NAME.xdc" * --exclude LICENSE README.md webxdc.js webxdc.d.ts icon.png "*screenshot*" "*marker-*png" "*-src*" "*.map" "*.sh" "*.xdc" *.DS_Store

echo "success, archive contents:"
unzip -l "$PACKAGE_NAME.xdc"

# check package size
MAXSIZE=655360
size=$(wc -c < "$PACKAGE_NAME.xdc")
if [ $size -ge $MAXSIZE ]; then
    echo "WARNING: package size exceeded the limit ($size > $MAXSIZE)"
fi

cp $PACKAGE_NAME.xdc ../../deltachat-ios/deltachat-ios/Assets

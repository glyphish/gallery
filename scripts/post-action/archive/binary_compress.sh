# Copy the app from the archive wrapper to the source root folder
${CP} -pR "$ARCHIVE_PRODUCTS_PATH/$INSTALL_PATH/$WRAPPER_NAME" "$SRCROOT"

# Optional, disk cleanup, remove the archive
rm -rf "${ARCHIVE_PATH}"

# get version suffix
# The defaults command can read/write to any plist file,
# just give it a path minus the .plist extension
BUILD_VERSION=-$(defaults read "$SRCROOT/$PRODUCT_NAME/$PRODUCT_NAME-Info" CFBundleVersion)

MARKETING_VERSION=-$(defaults read "$SRCROOT/$PRODUCT_NAME/$PRODUCT_NAME-Info" CFBundleShortVersionString)

# remove any old zip file
if [ -e "$PRODUCT_NAME$MARKETING_VERSION$BUILD_VERSION.zip" ] ; then
rm -f "$PRODUCT_NAME$MARKETING_VERSION$BUILD_VERSION.zip"
fi

# zip the app bundle using ditto
ditto -ck --keepParent "$SRCROOT/$PRODUCT_NAME.app" "$SRCROOT/$PRODUCT_NAME$MARKETING_VERSION$BUILD_VERSION.zip"

# remove the app we just zipped
rm -rf "$SRCROOT/$PRODUCT_NAME.app"

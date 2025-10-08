#!/bin/bash

ROOT_DIR="$(pwd)/../.."

export MACOSX_DEPLOYMENT_TARGET=10.14

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit

LIB_NAME="frostdart"
BUILD_DIR="../target/universal"
FRAMEWORK_NAME="${LIB_NAME}.framework"
XCFRAMEWORK_NAME="${LIB_NAME}.xcframework"

rm -rf "$BUILD_DIR" "$XCFRAMEWORK_NAME" "$ROOT_DIR"/macos/"$XCFRAMEWORK_NAME"

# attempt to rename crate in case it was renamed locally in order to build for ios
sed -i .bak 's/frostdart/hrf-api/' cargo.toml

echo "Building macos frostdart"

cargo lipo --release --targets aarch64-apple-darwin #,x86_64-apple-darwin

#for ARCH in aarch64 x86_64; do
for ARCH in aarch64; do
    ARCH_TARGET="${ARCH}-apple-darwin"
    OUT_DIR="$BUILD_DIR/$ARCH_TARGET"
    FRAMEWORK_DIR="$OUT_DIR/$FRAMEWORK_NAME"

    mkdir -p "$FRAMEWORK_DIR"

    cp "../target/$ARCH_TARGET/release/libhrf_api.dylib" "$FRAMEWORK_DIR/$LIB_NAME"

    echo "// Dummy header for $LIB_NAME" > "$FRAMEWORK_DIR/Headers/${LIB_NAME}.h"
    mkdir -p "$FRAMEWORK_DIR/Headers"
done

#    -framework "$BUILD_DIR/x86_64-apple-darwin/$FRAMEWORK_NAME" \
xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/aarch64-apple-darwin/$FRAMEWORK_NAME" \
    -output "../target/$XCFRAMEWORK_NAME"

mv "../target/$XCFRAMEWORK_NAME" "$ROOT_DIR"/macos/"$XCFRAMEWORK_NAME"


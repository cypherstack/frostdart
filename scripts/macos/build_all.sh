#!/bin/bash

ROOT_DIR="$(pwd)/../.."

export MACOSX_DEPLOYMENT_TARGET=10.14

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit

# attempt to rename crate in case it was renamed locally in order to build for ios
sed -i .bak 's/frostdart/hrf-api/' cargo.toml

echo "Building macos frostdart"

if [[ $(uname -m) == 'arm64' ]]; then
    cargo lipo --release --targets aarch64-apple-darwin
    cp ../target/aarch64-apple-darwin/release/libhrf_api.dylib "$ROOT_DIR"/macos/frostdart.dylib
else
    cargo lipo --release --targets x86_64-apple-darwin
    cp ../target/x86_64-apple-darwin/release/libhrf_api.dylib "$ROOT_DIR"/macos/frostdart.dylib
fi
#!/bin/bash

ROOT_DIR="$(pwd)/../.."

mkdir -p build

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit
if [ "$IS_ARM" = true ]  ; then
    echo "Building arm frostdart"
    cargo +1.71.0 build --target aarch64-unknown-linux-gnu --release --lib
    cp ../target/aarch64-unknown-linux-gnu/release/libhrf_api.so "$ROOT_DIR"/scripts/linux/build/frostdart.so
else
    echo "Building x86_64 frostdart"
    cargo +1.71.0 build --target x86_64-unknown-linux-gnu --release --lib
    cp ../target/x86_64-unknown-linux-gnu/release/libhrf_api.so "$ROOT_DIR"/scripts/linux/build/frostdart.so
fi
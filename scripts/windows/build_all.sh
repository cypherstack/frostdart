#!/bin/bash

ROOT_DIR="$(pwd)/../.."

mkdir -p build

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit

if [ "$IS_ARM" = true ] ; then
    echo "Building arm frostdart with GNU toolchain."
    echo "WARNING: aarch64-pc-windows-gnu may not be fully supported."
    rustup +1.71.0 target add aarch64-pc-windows-gnu
    cargo +1.71.0 build --target aarch64-pc-windows-gnu --release --lib
    cp ../target/aarch64-pc-windows-gnu/release/hrf_api.dll "$ROOT_DIR"/scripts/windows/build/frostdart.dll
else
    echo "Adding x86_64-pc-windows-gnu target."
    rustup +1.71.0 target add x86_64-pc-windows-gnu
    echo "Building x86_64 frostdart with GNU toolchain."
    cargo +1.71.0 build --target x86_64-pc-windows-gnu --release --lib
    cp ../target/x86_64-pc-windows-gnu/release/hrf_api.dll "$ROOT_DIR"/scripts/windows/build/frostdart.dll
fi

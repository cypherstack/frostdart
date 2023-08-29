#!/bin/bash

ROOT_DIR="$(pwd)/../.."

export MACOSX_DEPLOYMENT_TARGET=10.14

mkdir -p build

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit

echo "Building macos frostdart"
cargo lipo --release --targets aarch64-apple-darwin,x86_64-apple-darwin
cp ../target/universal/release/libhrf_api.a "$ROOT_DIR"/macos/frostdart.a
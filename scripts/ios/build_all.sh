#!/bin/bash

ROOT_DIR="$(pwd)/../.."

mkdir -p build

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit

echo "Building ios frostdart"
cargo lipo --release
cp ../target/universal/release/libhrf_api.a "$ROOT_DIR"/ios/frostdart.a
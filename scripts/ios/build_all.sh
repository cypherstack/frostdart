#!/bin/bash

ROOT_DIR="$(pwd)/../.."

mkdir -p build

rm -rf "$ROOT_DIR"/src/serai/target

cd "$ROOT_DIR"/src/serai/hrf || exit

# Build is handled by cargokit which requires the rust crate be named the same
sed -i .bak 's/hrf-api/frostdart/' cargo.toml
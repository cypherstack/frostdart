#!/bin/bash
set -e

LIB_ROOT=../..

cd "$LIB_ROOT/src/serai/hrf" || exit

# cargokit's artifact search uses the Cargo package name verbatim, but cargo
# normalizes dashes to underscores in the emitted filename. Rename so cargo's
# output ("libfrostdart.a") and the podspec's vendored_libraries entry agree.
# BSD sed (macOS) syntax; idempotent.
sed -i '' 's/^name = "hrf-api"$/name = "frostdart"/' Cargo.toml

export IPHONEOS_DEPLOYMENT_TARGET=15.0
export RUSTFLAGS="-C link-arg=-mios-version-min=15.0"
cargo build --target aarch64-apple-ios --release --lib

cp ../target/aarch64-apple-ios/release/libfrostdart.a \
   "$LIB_ROOT/ios/libfrostdart.a"

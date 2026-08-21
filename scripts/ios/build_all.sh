#!/bin/bash
set -e

# Absolute path to the frostdart repo root (this script lives in scripts/ios).
FROSTDART_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$FROSTDART_ROOT/src/serai/hrf" || exit

# cargokit's artifact search uses the Cargo package name verbatim, but cargo
# normalizes dashes to underscores in the emitted filename. Rename so cargo's
# output ("libfrostdart.a") and the podspec's vendored_frameworks entry agree.
# BSD sed (macOS) syntax; idempotent.
sed -i '' 's/^name = "hrf-api"$/name = "frostdart"/' Cargo.toml

# Build for both iOS device (aarch64-apple-ios) and the iOS Simulator on
# Apple Silicon (aarch64-apple-ios-sim). Both slices are arm64, so they
# cannot be combined with lipo; they are packaged as an XCFramework instead.
export IPHONEOS_DEPLOYMENT_TARGET=15.0
export CARGO_TARGET_AARCH64_APPLE_IOS_RUSTFLAGS="-C link-arg=-mios-version-min=15.0"
export CARGO_TARGET_AARCH64_APPLE_IOS_SIM_RUSTFLAGS="-C link-arg=-mios-simulator-version-min=15.0"

cargo build --target aarch64-apple-ios --release --lib
cargo build --target aarch64-apple-ios-sim --release --lib

DEVICE_LIB="../target/aarch64-apple-ios/release/libfrostdart.a"
SIM_LIB="../target/aarch64-apple-ios-sim/release/libfrostdart.a"
HEADERS_DIR="$FROSTDART_ROOT/src/serai/hrf"

# Keep the legacy device-only static library next to the podspec for any
# consumers that still reference it directly.
cp "$DEVICE_LIB" "$FROSTDART_ROOT/ios/libfrostdart.a"

# Package device + simulator slices as an XCFramework.
rm -rf "$FROSTDART_ROOT/ios/frostdart.xcframework"
xcodebuild -create-xcframework \
  -library "$DEVICE_LIB" -headers "$HEADERS_DIR" \
  -library "$SIM_LIB" -headers "$HEADERS_DIR" \
  -output "$FROSTDART_ROOT/ios/frostdart.xcframework"

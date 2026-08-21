#!/bin/bash
set -e

LIB_ROOT=../..
REPO="cypherstack/frostdart"
BASE_URL="https://github.com/${REPO}/releases/download"

TAG=$(git -C "$LIB_ROOT" describe --tags --exact-match HEAD 2>/dev/null) || {
    echo "Error: frostdart is not at a tagged commit."
    echo "Pin the submodule to a release tag to use download mode."
    echo "Current commit: $(git -C "$LIB_ROOT" rev-parse HEAD)"
    exit 1
}

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

curl -fSL "${BASE_URL}/${TAG}/checksums.txt" -o "$TMPDIR/checksums.txt"

download_and_verify() {
    local asset="$1"
    curl -fSL "${BASE_URL}/${TAG}/${asset}" -o "$TMPDIR/${asset}"
    grep "^[0-9a-f]*  ${asset}$" "$TMPDIR/checksums.txt" | (cd "$TMPDIR" && shasum -a 256 -c)
}

download_and_verify "frostdart-ios-aarch64.a"

cp "$TMPDIR/frostdart-ios-aarch64.a" "$LIB_ROOT/ios/libfrostdart.a"

# Release artifacts are device-only; wrap the device slice in an XCFramework
# so the podspec's vendored_frameworks entry resolves. Simulator consumers
# must build from source with scripts/ios/build_all.sh instead.
FROSTDART_ROOT="$(cd "$LIB_ROOT" && pwd)"
rm -rf "$FROSTDART_ROOT/ios/frostdart.xcframework"
xcodebuild -create-xcframework \
  -library "$FROSTDART_ROOT/ios/libfrostdart.a" \
  -headers "$FROSTDART_ROOT/src/serai/hrf" \
  -output "$FROSTDART_ROOT/ios/frostdart.xcframework"

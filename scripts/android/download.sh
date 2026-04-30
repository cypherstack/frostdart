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
    grep "^[0-9a-f]*  ${asset}$" "$TMPDIR/checksums.txt" | (cd "$TMPDIR" && sha256sum -c)
}

JNILIBS="$LIB_ROOT/android/src/main/jniLibs"

download_and_verify "frostdart-android-arm64-v8a.so"
mkdir -p "$JNILIBS/arm64-v8a"
cp "$TMPDIR/frostdart-android-arm64-v8a.so" "$JNILIBS/arm64-v8a/frostdart.so"

download_and_verify "frostdart-android-armeabi-v7a.so"
mkdir -p "$JNILIBS/armeabi-v7a"
cp "$TMPDIR/frostdart-android-armeabi-v7a.so" "$JNILIBS/armeabi-v7a/frostdart.so"

download_and_verify "frostdart-android-x86_64.so"
mkdir -p "$JNILIBS/x86_64"
cp "$TMPDIR/frostdart-android-x86_64.so" "$JNILIBS/x86_64/frostdart.so"

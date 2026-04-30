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

mkdir -p "$LIB_ROOT/windows/build"

download_and_verify "frostdart-windows-x86_64.dll"
cp "$TMPDIR/frostdart-windows-x86_64.dll" "$LIB_ROOT/scripts/windows/build/frostdart.dll"

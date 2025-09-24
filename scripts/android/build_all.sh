#!/bin/bash

export API=28

WORKDIR="$(pwd)/"build
export WORKDIR

ROOT_DIR="$(pwd)/../.."

mkdir -p build

export ANDROID_NDK_ZIP=${WORKDIR}/android-ndk-r28c.zip
export ANDROID_NDK_ROOT=${WORKDIR}/android-ndk-r28c
ANDROID_NDK_SHA256="a7b54a5de87fecd125a17d54f73c446199e72a64"
if [ ! -e "$ANDROID_NDK_ZIP" ]; then
  curl https://dl.google.com/android/repository/android-ndk-r28c-linux.zip -o "${ANDROID_NDK_ZIP}"
fi
echo $ANDROID_NDK_SHA256 "$ANDROID_NDK_ZIP" | sha1sum -c || exit 1
unzip "$ANDROID_NDK_ZIP" -d "$WORKDIR"

export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT

export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=aarch64-linux-android
export API=33
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$TOOLCHAIN/bin

# inject absolute linker path into cargo config
LINKER_PATH="$TOOLCHAIN"/bin/aarch64-linux-android33-clang
cp -R .cargo build/
sed -i "s#replaceme#${LINKER_PATH}#g" build/.cargo/config

cp -R "$ROOT_DIR"/src/serai build/
cd build/serai/hrf || exit

# inject vendored openssl required for android cross compilation
sed -i "s/\[dependencies\]/\[dependencies\]\\
openssl = { version = \"0.10\", features = [\"vendored\"] }/" Cargo.toml

rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
cargo ndk \
  --target armv7-linux-androideabi \
  --target aarch64-linux-android \
  --target x86_64-linux-android \
  --output-dir "$ROOT_DIR"/android/src/main/jniLibs \
  --platform 21 \
  build --release

mv "$ROOT_DIR"/android/src/main/jniLibs/armeabi-v7a/libhrf_api.so "$ROOT_DIR"/android/src/main/jniLibs/armeabi-v7a/frostdart.so
mv "$ROOT_DIR"/android/src/main/jniLibs/arm64-v8a/libhrf_api.so "$ROOT_DIR"/android/src/main/jniLibs/arm64-v8a/frostdart.so
mv "$ROOT_DIR"/android/src/main/jniLibs/x86_64/libhrf_api.so "$ROOT_DIR"/android/src/main/jniLibs/x86_64/frostdart.so

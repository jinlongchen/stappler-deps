#!/bin/bash

if [ -z "$ANDROID_NDK_ROOT" ]; then
NDK="/home/sbkarr/android/ndk"
else
NDK="$ANDROID_NDK_ROOT"
fi

function make_toolchains() {

TOOLCHAINS_DIR=`pwd`/android/toolchains
rm -rf $TOOLCHAINS_DIR
mkdir -p $TOOLCHAINS_DIR

$NDK/build/tools/make_standalone_toolchain.py --arch=arm --api 14 --stl=libc++ --install-dir=$TOOLCHAINS_DIR/armeabi-v7a
$NDK/build/tools/make_standalone_toolchain.py --arch=x86 --api 14 --stl=libc++ --install-dir=$TOOLCHAINS_DIR/x86
$NDK/build/tools/make_standalone_toolchain.py --arch=x86_64 --api 21 --stl=libc++ --install-dir=$TOOLCHAINS_DIR/x86_64
$NDK/build/tools/make_standalone_toolchain.py --arch=arm64 --api 21 --stl=libc++ --install-dir=$TOOLCHAINS_DIR/arm64-v8a

}

function build() {
	export ANDROID_NDK_ROOT=$NDK

	cd android
	./jpeg-android.sh
	./libpng-android.sh
	./libwebp-android.sh
	./brotli-android.sh
	./mbedtls-android.sh
	./curl-android.sh
	./freetype-android.sh
	./sqlite-android.sh
	./hyphen-android.sh
	cd -
}

function export_dir() {
	rm -f android/$1/include/png*
	rm -rf android/$1/include/freetype
	cp android/$1/include/libpng16/* android/$1/include
	mv android/$1/include/freetype2/* android/$1/include
}

function export_files() {
	export_dir arm64-v8a
	export_dir armeabi-v7a
	export_dir x86
	export_dir x86_64
}

if [ -z "$1" ]; then
make_toolchains
build
export_files
fi

if [ "$1" == "export" ]; then
echo "Export files..."
export_files
fi

if [ "$1" == "toolchains" ]; then
make_toolchains
fi

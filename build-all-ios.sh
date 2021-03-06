#!/bin/bash

function build() {
	cd ios
	./jpeg-ios.sh
	./libpng-ios.sh
	./libwebp-ios.sh
	./brotli-ios.sh
	./curl-ios.sh
	./freetype-ios.sh
	./hyphen-ios.sh
	cd -
}

function export_dir() {
	rm -f ios/$1/include/png*
	rm -rf ios/$1/include/freetype
	cp ios/$1/include/libpng16/* ios/$1/include
	cp -R ios/$1/include/freetype2/* ios/$1/include
}

function export_lib() {
	mkdir -p lib
	lipo -create -output lib/$1.a \
		ios/x86_64/lib/$1.a \
		ios/i386/lib/$1.a \
		ios/armv7/lib/$1.a \
		ios/armv7s/lib/$1.a \
		ios/arm64/lib/$1.a
}

function export_files() {
	export_dir i386
	export_dir x86_64
	export_dir armv7
	export_dir armv7s
	export_dir arm64
}

if [ -z "$1" ]; then
build
export_files
fi

if [ "$1" == "export" ]; then
echo "Export files..."
export_files
fi

#!/bin/bash

# May be able to minimise these flags
FFMPEG_FLAGS="--disable-static --enable-shared --enable-gpl --enable-version3 --disable-w32threads --enable-bzlib --enable-fontconfig --enable-gnutls --enable-iconv --enable-libfreetype --enable-libgsm --enable-librtmp --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvpx --enable-libx264 --enable-libxvid --enable-zlib"

# Change these to update ffmpeg
BRANCH="release/8.1"
FFMPEG_REPO="https://github.com/FFmpeg/FFmpeg"
CWD=$(pwd)
WORKSPACE="$CWD/workspace"

CFLAGS="-I$WORKSPACE/FFmpeg/include -Wno-int-conversion"
LDFLAGS="-L$WORKSPACE/FFmpeg/lib"

NUMCORES=$(nproc --all)

make_workspace() {
   mkdir -p $WORKSPACE
}

build_etterna_linux() {
   git clone $FFMPEG_REPO
   cd FFmpeg
   git checkout $BRANCH


   if [ "$(uname -m)"  == "x86" ]; then
	FFMPEG_FLAGS+='--extra-cflags="-m32" --extra-ldflags="-m32"'
   fi

   ./configure --prefix="$WORKSPACE" \
	   $FFMPEG_FLAGS \
	   --extra-cflags="${CFLAGS}" \
	   --extra-ldflags="${LDFLAGS}" \
	   --pkgconfigdir="$WORKSPACE/FFmpeg/lib/pkgconfig" \
	   --pkg-config-flags="--static" \

   make -j $NUMCORES
   make install
}

make_workspace
cd workspace
build_etterna_linux

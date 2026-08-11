#!/bin/bash

# NOTE: This includes 32bit installation flags if we ever need them

# May be able to minimise these flags
FFMPEG_FLAGS+="--disable-static --enable-shared --enable-gpl --enable-version3 --disable-w32threads --enable-bzlib --enable-fontconfig --enable-gnutls --enable-iconv --enable-libfreetype --enable-libgsm --enable-librtmp --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvpx --enable-libx264 --enable-libxvid --enable-zlib"

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

generic_build() {
    git clone $FFMPEG_REPO
    cd FFmpeg
    git checkout $BRANCH


    ./configure --prefix="$WORKSPACE" \
        $FFMPEG_FLAGS \
        --ld="g++" \
        --extra-cflags="${CFLAGS}" \
        --extra-ldflags="${LDFLAGS}" \
        --pkgconfigdir="$WORKSPACE/FFmpeg/lib/pkgconfig" \
        --pkg-config-flags="--static"

    make -j $NUMCORES
    make install
}

make_workspace
cd workspace
generic_build

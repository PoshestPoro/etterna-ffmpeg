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

linux_build() {
    if [ "$(uname -m)"  == "x86" ]; then
        FFMPEG_FLAGS+='--extra-cflags="-m32" --extra-ldflags="-m32"'
    fi
    generic_build
}

windows_build() {
    if [ $1 == "x86" ]; then
        FFMPEG_FLAGS+='--arch=x86 --target-os=mingw32 --cross-prefix=i686-w64-mingw32'
    elif [ $1 == "x86_64" ]; then
        FFMPEG_FLAGS+='--arch=x86_64 --target-os=mingw32 --cross-prefix=x86_64-w64-mingw32'
    else
        echo "Invalid parameter to windows_build, only x86 and x86_64 are accepted - you put in $1"
        exit
    fi
    generic_build
}

make_workspace
cd workspace
linux_build

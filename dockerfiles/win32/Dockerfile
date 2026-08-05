ARG GH_REPO=ghcr.io/poshestporo/etterna-ffmpeg
FROM $GH_REPO/base:latest

RUN --mount=src=ct-ng-config,dst=/.config \
    git clone --filter=blob:none https://github.com/crosstool-ng/crosstool-ng.git /ct-ng && cd /ct-ng && \
    ./bootstrap && \
    ./configure --enable-local && \
    make -j$(nproc) && \
    cp /.config .config && \
    ./ct-ng build && \ 
    cd / && \
    rm -rf ct-ng

# Prepare "cross" environment to heavily favour static builds
RUN \
    find /opt/ct-ng \( \
        -name "*.dll" \
        -or -name "*.dll.a" \
        \) -delete && \
    mkdir /opt/ffbuild

RUN \
    dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y install --no-install-recommends wine32 wine && \
    apt-get -y clean autoclean && \
    rm -rf /var/lib/apt/lists/*

ENV FFBUILD_TOOLCHAIN=i686-w64-mingw32

ENV PATH="/opt/ct-ng/bin:${PATH}" \
    CC="${FFBUILD_TOOLCHAIN}-gcc" \
    CXX="${FFBUILD_TOOLCHAIN}-g++" \
    LD="${FFBUILD_TOOLCHAIN}-ld" \
    AR="${FFBUILD_TOOLCHAIN}-gcc-ar"


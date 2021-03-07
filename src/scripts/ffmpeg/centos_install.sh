# 作者: 石晓旭
# 日期: 2021年03月05日
# 描述: 安装FFMPEG浏览器，在centos系统.
# 在线安装: sudo /bin/bash -c "$(curl -fsSL https://files.shixiaoxu.com/scripts/ffmpeg/centos_install.sh)"

# install required software package
BUILD_BASE_DIR=$(pwd)
BUILD_TEMP_DIR=$BUILD_BASE_DIR/temp
BUILD_OUT_DIR=/usr

_BUILD_FFMPEG_INSTALL_DIR=1
export BUILD_FFMPEG_INSTALL_DIR=1
echo " "
echo "FFMPEG install directory enum :"
echo " 1) /usr"
echo " 2) /usr/local"
echo " 3) /opt/janus"
read -p "Please select the ffmpeg install directory for this instance: [${_BUILD_FFMPEG_INSTALL_DIR}] " BUILD_FFMPEG_INSTALL_DIR
if [[ $BUILD_FFMPEG_INSTALL_DIR -lt 1 ]] || [[ $BUILD_FFMPEG_INSTALL_DIR -gt 3 ]] ; then
    echo "Selecting default: $_BUILD_FFMPEG_INSTALL_DIR"
    BUILD_FFMPEG_INSTALL_DIR=${_BUILD_FFMPEG_INSTALL_DIR}
fi

if [ $BUILD_FFMPEG_INSTALL_DIR -eq 1 ] ; then
    BUILD_OUT_DIR="/usr"
elif [ $BUILD_FFMPEG_INSTALL_DIR -eq 2 ] ; then
    BUILD_OUT_DIR="/usr/local"
elif [ $BUILD_FFMPEG_INSTALL_DIR -eq 3 ] ; then
    BUILD_OUT_DIR="/opt/janus"
else
    exit
fi

echo "install directory : $BUILD_OUT_DIR"

export PATH="$PATH:$BUILD_OUT_DIR/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BUILD_OUT_DIR/lib:$BUILD_OUT_DIR/lib64"
export LD_RUN_PATH="$LD_RUN_PATH:$BUILD_OUT_DIR/lib:$BUILD_OUT_DIR/lib64"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$BUILD_OUT_DIR/lib/pkgconfig"

if [ ! -d "$BUILD_TEMP_DIR" ]; then
    mkdir -p $BUILD_TEMP_DIR
fi

yum install -y autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel

# build and install nasm
# An assembler used by some libraries. Highly recommended or your resulting build may be very slow.
cd $BUILD_TEMP_DIR
if [ ! -f "nasm-2.14.02.tar.bz2" ]; then
    #curl -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/nasm-2.14.02.tar.bz2
fi
if [ -d "nasm-2.14.02" ]; then
    rm -rf nasm-2.14.02
fi
tar xjvf nasm-2.14.02.tar.bz2
cd nasm-2.14.02
./autogen.sh
./configure --prefix="$BUILD_OUT_DIR" --bindir="$BUILD_OUT_DIR/bin"
make
make install

# build and install Yasm
# An assembler used by some libraries. Highly recommended or your resulting build may be very slow.
cd $BUILD_TEMP_DIR
if [ ! -f "yasm-1.3.0.tar.gz" ]; then
    #curl -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/yasm-1.3.0.tar.gz
fi
if [ -d "yasm-1.3.0" ]; then
    rm -rf yasm-1.3.0
fi
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$BUILD_OUT_DIR" --bindir="$BUILD_OUT_DIR/bin"
make
make install

# build and install libx264
# H.264 video encoder. See the H.264 Encoding Guide for more information and usage examples.
# Requires ffmpeg to be configured with --enable-gpl --enable-libx264.
cd $BUILD_TEMP_DIR
if [ ! -f "x264-20200819.tar.xz" ]; then
    #git clone --depth 1 https://code.videolan.org/videolan/x264.git
    #curl -O -L http://anduin.linuxfromscratch.org/BLFS/x264/x264-20200819.tar.xz
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/x264-20200819.tar.xz
fi
if [ -d "x264" ]; then
    rm -rf x264
fi
xz -d x264-20200819.tar.xz
tar -xvf x264-20200819.tar
mv x264-20200819 x264
cd x264
./configure --prefix="$BUILD_OUT_DIR" --bindir="$BUILD_OUT_DIR/bin" --enable-static
make
make install

# build and install libx265
# H.265/HEVC video encoder. See the H.265 Encoding Guide for more information and usage examples.
# Requires ffmpeg to be configured with --enable-gpl --enable-libx265.
cd $BUILD_TEMP_DIR
if [ ! -f "x265_3.4.tar.gz" ]; then
    # hg clone https://bitbucket.org/multicoreware/x265
    #curl -O -L http://anduin.linuxfromscratch.org/BLFS/x265/x265_3.4.tar.gz
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/x265_3.4.tar.gz
fi
if [ -d "x265" ]; then
    rm -rf x265
fi
tar -xzvf x265_3.4.tar.gz
mv x265_3.4 x265
cd x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$BUILD_OUT_DIR" -DENABLE_SHARED:bool=off ../../source
make
make install

# build and install libfdk_aac
# AAC audio encoder. See the AAC Audio Encoding Guide for more information and usage examples.
# Requires ffmpeg to be configured with --enable-libfdk_aac (and --enable-nonfree if you also included --enable-gpl).
cd $BUILD_TEMP_DIR
if [ ! -f "fdk-aac.git.tar.gz" ]; then
    #git clone --depth 1 https://github.com/mstorsjo/fdk-aac
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/fdk-aac.git.tar.gz
fi
if [ -d "fdk-aac" ]; then
    rm -rf fdk-aac
fi
tar xzvf fdk-aac.git.tar.gz
cd fdk-aac
autoreconf -fiv
./configure --prefix="$BUILD_OUT_DIR" --disable-shared
make
make install

# build and install libmp3lame
# MP3 audio encoder.
# Requires ffmpeg to be configured with --enable-libmp3lame.
cd $BUILD_TEMP_DIR
if [ ! -f "lame-3.100.tar.gz" ]; then
    #curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/lame-3.100.tar.gz
fi
if [ -d "lame-3.100" ]; then
    rm -rf lame-3.100
fi
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$BUILD_OUT_DIR" --bindir="$BUILD_OUT_DIR/bin" --disable-shared --enable-nasm
make
make install

# build and install libopus
# Opus audio decoder and encoder.
# Requires ffmpeg to be configured with --enable-libopus.
cd $BUILD_TEMP_DIR
if [ ! -f "opus-1.3.1.tar.gz" ]; then
    #curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/opus-1.3.1.tar.gz
fi
if [ -d "opus-1.3.1" ]; then
    rm -rf opus-1.3.1
fi
tar xzvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix="$BUILD_OUT_DIR" --enable-shared --enable-static --with-pic
make
make install

# libvpx
# VP8/VP9 video encoder and decoder. See the VP9 Video Encoding Guide for more information and usage examples.
# Requires ffmpeg to be configured with --enable-libvpx.
cd $BUILD_TEMP_DIR
if [ ! -f "libvpx-1.9.0.tar.gz" ]; then
    # git clone --depth 1 https://github.com/webmproject/libvpx.git
    #curl -O -L https://github.com/webmproject/libvpx/archive/v1.9.0/libvpx-1.9.0.tar.gz
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/libvpx-1.9.0.tar.gz
fi
if [ -d "libvpx-1.9.0" ]; then
    rm -rf libvpx-1.9.0
fi
tar xzvf libvpx-1.9.0.tar.gz
cd libvpx-1.9.0
./configure --prefix="$BUILD_OUT_DIR" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make
make install

# build and install FFmpeg
cd $BUILD_TEMP_DIR
if [ ! -f "ffmpeg-snapshot.tar.bz2" ]; then
    #curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    curl -O -L https://files.shixiaoxu.com/packages/ffmepg/snapshot/ffmpeg-snapshot.tar.bz2
fi
if [ -d "ffmpeg" ]; then
    rm -rf ffmpeg
fi
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$BUILD_OUT_DIR/bin:$PATH" PKG_CONFIG_PATH="$BUILD_OUT_DIR/lib/pkgconfig" ./configure \
    --prefix="$BUILD_OUT_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$BUILD_OUT_DIR/include" \
    --extra-ldflags="-L$BUILD_OUT_DIR/lib" \
    --extra-libs=-lpthread \
    --extra-libs=-lm \
    --bindir="$BUILD_OUT_DIR/bin" \
    --enable-gpl \
    --enable-libfdk_aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree \
    --enable-encoder=libvpx_vp8 \
    --enable-encoder=libvpx_vp9 \
    --enable-decoder=vp8 \
    --enable-decoder=vp9 \
    --enable-parser=vp8 \
    --enable-parser=vp9
make -j 8
make install

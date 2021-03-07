# 作者: 石晓旭
# 日期：2021年02月01日
# 描述：自动编译安装Janus
# 在线安装: sudo /bin/bash -c "$(curl -fsSL https://files.shixiaoxu.com/scripts/janus/ubuntu_install.sh)"

#!/bin/bash

Janus_0_10_9_Url=https://files.shixiaoxu.com/packages/janus/janus-gateway-0.10.9.tar.gz
Janus_0_10_9_Tar=janus-gateway-0.10.9.tar.gz
Janus_0_10_9_Pkg=janus-gateway

libnice_url=https://files.shixiaoxu.com/packages/janus/libs/libnice.tar.gz
libnice_tar=libnice.tar.gz
libnice_pkg=libnice

libsrtp_url=https://files.shixiaoxu.com/packages/janus/libs/libsrtp.2.2.0.tar.gz
libsrtp_tar=libsrtp.2.2.0.tar.gz
libsrtp_pkg=libsrtp-2.2.0

libusrsctp_url=https://files.shixiaoxu.com/packages/janus/libs/usrsctp.tar.gz
libusrsctp_tar=usrsctp.tar.gz
libusrsctp_pkg=usrsctp

libwebsocket_url=https://files.shixiaoxu.com/packages/janus/libs/libwebsockets.tar.gz
libwebsocket_tar=libwebsockets.tar.gz
libwebsocket_pkg=libwebsockets

librabbitmq_url=https://files.shixiaoxu.com/packages/janus/libs/rabbitmq-c.tar.gz
librabbitmq_tar=rabbitmq-c.tar.gz
librabbitmq_pkg=rabbitmq-c

libmicrohttpd_url=https://files.shixiaoxu.com/packages/janus/libs/libmicrohttpd-0.9.72.tar.gz
libmicrohttpd_tar=libmicrohttpd-0.9.72.tar.gz
libmicrohttpd_pkg=libmicrohttpd-0.9.72

libsofiasip_url=https://files.shixiaoxu.com/packages/janus/libs/sofia-sip.tar.gz
libsofiasip_tar=sofia-sip.tar.gz
libsofiasip_pkg=sofia-sip

libopus_url=https://files.shixiaoxu.com/packages/ffmepg/snapshot/opus-1.3.1.tar.gz
libopus_tar=opus-1.3.1.tar.gz
libopus_pkg=opus-1.3.1

JanusCurrentUrl=${Janus_0_10_9_Url}
JanusCurrentTar=${Janus_0_10_9_Tar}
JanusCurrentPkg=${Janus_0_10_9_Pkg}

BuildBaseDir=$(pwd)
BuildTempDir=${BuildBaseDir}/temp
BuildCodeDir=${BuildBaseDir}/${JanusCurrentPkg}
BuildOutDir="/opt/janus"
BuildDepsOutDir=${BuildOutDir}
BuildLDLibDir="${LD_LIBRARY_PATH}:${BuildDepsOutDir}/lib:${BuildDepsOutDir}/lib64:${BuildDepsOutDir}/lib/x86_64-linux-gnu"
BuildLDRunDir="${LD_RUN_PATH}:${BuildDepsOutDir}/lib:${BuildDepsOutDir}/lib64:${BuildDepsOutDir}/lib/x86_64-linux-gnu"
BuildPkgCfgDir="${PKG_CONFIG_PATH}:${BuildDepsOutDir}/lib/pkgconfig:${BuildDepsOutDir}/lib64/pkgconfig:${BuildDepsOutDir}/lib/x86_64-linux-gnu/pkgconfig"
# print path
echo "JanusCurrentUrl   : ${JanusCurrentUrl} ..."
echo "JanusCurrentTar   : ${JanusCurrentTar} ..."
echo "JanusCurrentPkg   : ${JanusCurrentPkg} ..."
echo " "
echo "BuildBaseDir      : ${BuildBaseDir} ..."
echo "BuildTempDir      : ${BuildTempDir} ..."
echo "BuildCodeDir      : ${BuildCodeDir} ..."
echo "BuildOutDir       : ${BuildOutDir} ..."
echo "BuildDepsOutDir   : ${BuildDepsOutDir} ..."
echo "BuildLDRunDir     : ${BuildLDRunDir} ..."
echo "BuildLDLibDir     : ${BuildLDLibDir} ..."
echo "BuildPkgCfgDir    : ${BuildPkgCfgDir} ..."
echo " "
echo "libnice_url       : ${libnice_url} ..."
echo "libnice_tar       : ${libnice_tar} ..."
echo "libnice_pkg       : ${libnice_pkg} ..."
echo " "
echo "libsrtp_url       : ${libsrtp_url} ..."
echo "libsrtp_tar       : ${libsrtp_tar} ..."
echo "libsrtp_pkg       : ${libsrtp_pkg} ..."
echo " "
echo "libusrsctp_url    : ${libusrsctp_url} ..."
echo "libusrsctp_tar    : ${libusrsctp_tar} ..."
echo "libusrsctp_pkg    : ${libusrsctp_pkg} ..."
echo " "
echo "libwebsocket_url  : ${libwebsocket_url} ..."
echo "libwebsocket_tar  : ${libwebsocket_tar} ..."
echo "libwebsocket_pkg  : ${libwebsocket_pkg} ..."
echo " "
echo "librabbitmq_url   : ${librabbitmq_url} ..."
echo "librabbitmq_tar   : ${librabbitmq_tar} ..."
echo "librabbitmq_pkg   : ${librabbitmq_pkg} ..."
echo " "
echo "libmicrohttpd_url : ${libmicrohttpd_url} ..."
echo "libmicrohttpd_tar : ${libmicrohttpd_tar} ..."
echo "libmicrohttpd_pkg : ${libmicrohttpd_pkg} ..."
echo " "
echo "libsofiasip_url   : ${libsofiasip_url} ..."
echo "libsofiasip_tar   : ${libsofiasip_tar} ..."
echo "libsofiasip_pkg   : ${libsofiasip_pkg} ..."
echo " "
echo "libopus_url       : ${libopus_url} ..."
echo "libopus_tar       : ${libopus_tar} ..."
echo "libopus_pkg       : ${libopus_pkg} ..."

if [ ! -d "$BuildTempDir" ]; then
    mkdir -p $BuildTempDir
fi

_BuildEnablePostProcessing=1
export BuildEnablePostProcessing=1
echo " "
echo "Build Janus Enable Post Processing : "
echo "    1) Enable"
echo "    2) Disable"
read -p "Please select the enable-post-processing for this instance: [${_BuildEnablePostProcessing}] " BuildEnablePostProcessing
if ! echo $BuildEnablePostProcessing | egrep -q '^[1‐2]+$'; then
    echo "Selecting default: $_BuildEnablePostProcessing"
    BuildEnablePostProcessing=$_BuildEnablePostProcessing
fi

if [ $BuildEnablePostProcessing == 1 ]; then
    . ./build_ffmpeg.sh
fi

# depends tools
sudo apt-get update
sudo apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    libtool \
    git \
    wget \
    pkg-config \
    libglib2.0-dev \
    libconfig-dev
# libnice
sudo apt-get install -y meson libssl-dev
cd ${BuildTempDir}
if [ ! -f ${libnice_tar} ]; then
    wget ${libnice_url}
fi

if [ -d ${libnice_pkg} ]; then
    rm -rf ${libnice_pkg}
fi
tar xzvf ${libnice_tar}
cd ${libnice_pkg}
meson --prefix=${BuildDepsOutDir} build && ninja -C build && sudo ninja -C build install

# libsrtp
sudo apt-get install -y libssl-dev
cd ${BuildTempDir}
if [ ! -f ${libsrtp_tar} ]; then
    wget ${libsrtp_url}
fi

if [ -d ${libsrtp_pkg} ]; then
    rm -rf ${libsrtp_pkg}
fi
tar xzvf ${libsrtp_tar}
cd ${libsrtp_pkg}
./configure --prefix=${BuildDepsOutDir} --enable-openssl && make shared_library && sudo make install

# usrsctp
cd ${BuildTempDir}
if [ ! -f ${libusrsctp_tar} ]; then
    wget ${libusrsctp_url}
fi

if [ -d ${libusrsctp_pkg} ]; then
    rm -rf ${libusrsctp_pkg}
fi
tar xzvf ${libusrsctp_tar}
cd ${libusrsctp_pkg}
./bootstrap && ./configure --prefix=${BuildDepsOutDir} --disable-programs --disable-inet --disable-inet6 && make && sudo make install

# websocket
cd ${BuildTempDir}
if [ ! -f ${libwebsocket_tar} ]; then
    wget ${libwebsocket_url}
fi

if [ -d ${libwebsocket_pkg} ]; then
    rm -rf ${libwebsocket_pkg}
fi
tar xzvf ${libwebsocket_tar}
cd ${libwebsocket_pkg}
mkdir build
cd build
cmake -DLWS_MAX_SMP=1 -DCMAKE_INSTALL_PREFIX:PATH=${BuildDepsOutDir} -DCMAKE_C_FLAGS="-fpic" .. && make && sudo make install

# rabbitmq
cd ${BuildTempDir}
if [ ! -f ${librabbitmq_tar} ]; then
    wget ${librabbitmq_url}
fi

if [ -d ${librabbitmq_pkg} ]; then
    rm -rf ${librabbitmq_pkg}
fi
tar xzvf ${librabbitmq_tar}
cd ${librabbitmq_pkg}
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${BuildDepsOutDir} .. && make && sudo make install

# libmicrohttpd
cd ${BuildTempDir}
if [ ! -f ${libmicrohttpd_tar} ]; then
    wget ${libmicrohttpd_url}
fi

if [ -d ${libmicrohttpd_pkg} ]; then
    rm -rf ${libmicrohttpd_pkg}
fi
tar xzvf ${libmicrohttpd_tar}
cd ${libmicrohttpd_pkg}
./configure --prefix=${BuildDepsOutDir} && make && sudo make install

# libsofia-sip
cd ${BuildTempDir}
if [ ! -f ${libsofiasip_tar} ]; then
    wget ${libsofiasip_url}
fi

if [ -d ${libsofiasip_pkg} ]; then
    rm -rf ${libsofiasip_pkg}
fi
tar xzvf ${libsofiasip_tar}
cd ${libsofiasip_pkg}
./bootstrap.sh && ./configure --prefix=${BuildDepsOutDir} && make && sudo make install

# libopus
cd ${BuildTempDir}
if [ ! -f "${libopus_tar}" ]; then
    wget ${libopus_url}
fi
if [ -d "${libopus_pkg}" ]; then
    rm -rf ${libopus_pkg}
fi
tar xzvf ${libopus_tar}
cd ${libopus_pkg}
./configure --prefix="${BuildDepsOutDir}" --enable-shared --enable-static --with-pic && make && sudo make install

# yum install depends
# libsrtp-dev libsofia-sip-ua-dev libopus-dev
sudo apt-get install -y libjansson-dev \
    libssl-dev libglib2.0-dev \
    libogg-dev libcurl4-openssl-dev liblua5.3-dev \
    libconfig-dev pkg-config gengetopt libtool automake
# janus
cd ${BuildTempDir}
if [ ! -f ${Janus_0_10_9_Tar} ]; then
    wget ${JanusCurrentUrl}
fi

if [ -d ${JanusCurrentPkg} ]; then
    rm -rf ${JanusCurrentPkg}
fi

tar -xzvf ${Janus_0_10_9_Tar}
cd ${JanusCurrentPkg}
./autogen.sh
if [ $BuildEnablePostProcessing == 1 ]; then
    ./configure --prefix=${BuildOutDir} --enable-openssl --enable-plugin-duktape --enable-post-processing \
        PKG_CONFIG_PATH=${BuildPkgCfgDir} \
        LD_LIBRARY_PATH=${BuildLDLibDir} \
        LD_RUN_PATH=${BuildLDRunDir} \
        LDFLAGS="-L/opt/janus/lib -L/opt/janus/lib/x86_64-linux-gnu" \
        CPPFLAGS="-I/opt/janus/include"
else
    ./configure --prefix=${BuildOutDir} --enable-openssl --enable-plugin-duktape \
        PKG_CONFIG_PATH=${BuildPkgCfgDir} \
        LD_LIBRARY_PATH=${BuildLDLibDir} \
        LD_RUN_PATH=${BuildLDRunDir} \
        LDFLAGS="-L/opt/janus/lib -L/opt/janus/lib/x86_64-linux-gnu" \
        CPPFLAGS="-I/opt/janus/include"
fi

sudo make -j 4
sudo make install

# 作者: 石晓旭
# 日期：2021年02月01日
# 描述：自动编译安装Janus
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

JanusCurrentUrl=${Janus_0_10_9_Url}
JanusCurrentTar=${Janus_0_10_9_Tar}
JanusCurrentPkg=${Janus_0_10_9_Pkg}

BuildBaseDir=`pwd`
BuildTempDir=${BuildBaseDir}/temp
BuildCodeDir=${BuildBaseDir}/${JanusCurrentPkg}

# janus depends install directory.
BuildDepsOutDir=""
_BUILD_JANUS_DEPS_INSTALL_DIR=1
export BUILD_JANUS_DEPS_INSTALL_DIR=1
echo " "
echo "Janus depends install directory enum :"
echo " 1) /usr"
echo " 2) /usr/local"
echo " 3) /opt/janus"
read -p "Please select the janus depends install directory for this instance: [${_BUILD_JANUS_DEPS_INSTALL_DIR}] " BUILD_JANUS_DEPS_INSTALL_DIR
if [[ $BUILD_JANUS_DEPS_INSTALL_DIR -lt 1 ]] || [[ $BUILD_JANUS_DEPS_INSTALL_DIR -gt 3 ]] ; then
    echo "Selecting default: $_BUILD_JANUS_DEPS_INSTALL_DIR"
    BUILD_JANUS_DEPS_INSTALL_DIR=${_BUILD_JANUS_DEPS_INSTALL_DIR}
fi
echo $BUILD_JANUS_DEPS_INSTALL_DIR
if [ $BUILD_JANUS_DEPS_INSTALL_DIR -eq 1 ] ; then
    BuildDepsOutDir="/usr"
elif [ $BUILD_JANUS_DEPS_INSTALL_DIR -eq 2 ] ; then
    BuildDepsOutDir="/usr/local"
elif [ $BUILD_JANUS_DEPS_INSTALL_DIR -eq 3 ] ; then
    BuildDepsOutDir="/opt/janus"
else
    exit
fi

# Janus install directory.
BuildOutDir=""
_BUILD_JANUS_INSTALL_DIR=1
export BUILD_JANUS_INSTALL_DIR=1
echo " "
echo "Janus install directory enum :"
echo " 1) /opt/janus"
echo " 2) /usr/local"
echo " 3) /usr"
read -p "Please select the janus install directory for this instance: [${_BUILD_JANUS_INSTALL_DIR}] " BUILD_JANUS_INSTALL_DIR
if [[ $BUILD_JANUS_INSTALL_DIR -lt 1 ]] || [[ $BUILD_JANUS_INSTALL_DIR -gt 3 ]] ; then
    echo "Selecting default: $_BUILD_JANUS_INSTALL_DIR"
    BUILD_JANUS_INSTALL_DIR=${_BUILD_JANUS_INSTALL_DIR}
fi
echo $BUILD_JANUS_INSTALL_DIR
if [ $BUILD_JANUS_INSTALL_DIR -eq 1 ] ; then
    BuildOutDir="/opt/janus"
elif [ $BUILD_JANUS_INSTALL_DIR -eq 2 ] ; then
    BuildOutDir="/usr/local"
elif [ $BUILD_JANUS_INSTALL_DIR -eq 3 ] ; then
    BuildOutDir="/usr"
else
    exit
fi

BuildLDLibDir="${LD_LIBRARY_PATH}:${BuildDepsOutDir}/lib:${BuildDepsOutDir}/lib64"
BuildLDRunDir="${LD_RUN_PATH}:${BuildDepsOutDir}/lib:${BuildDepsOutDir}/lib64"
BuildPkgCfgDir="${PKG_CONFIG_PATH}:${BuildDepsOutDir}/lib/pkgconfig:${BuildDepsOutDir}/lib64/pkgconfig"
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
# set env
export PKG_CONFIG_PATH=${BuildPkgCfgDir}
export LD_LIBRARY_PATH=${BuildLDLibDir}
export LD_RUN_PATH=${BuildLDRunDir}
exit
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
if ! echo $BuildEnablePostProcessing | egrep -q '^[1‐2]+$' ; then
    echo "Selecting default: $_BuildEnablePostProcessing"
    BuildEnablePostProcessing=$_BuildEnablePostProcessing
fi

if [ $BuildEnablePostProcessing == 1 ]; then
    . ./build_ffmpeg.sh
fi

# depends tools
yum install -y epel-release
yum install -y git wget gcc-c++ libconfig-devel libtool autoconf automake cmake glib2-devel
# libnice
yum install -y meson openssl-devel
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
yum install -y openssl-devel
cd ${BuildTempDir}
if [ ! -f ${libsrtp_tar} ]; then
    wget ${libsrtp_url}
fi

if [ -d ${libsrtp_pkg} ]; then
    rm -rf ${libsrtp_pkg}
fi
tar xzvf ${libsrtp_tar}
cd ${libsrtp_pkg}
./configure --prefix=${BuildDepsOutDir} --enable-openssl
make shared_library && make install
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
./bootstrap && ./configure --prefix=${BuildDepsOutDir} --disable-programs --disable-inet --disable-inet6 && make && make install
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
cmake -DLWS_MAX_SMP=1 -DCMAKE_INSTALL_PREFIX:PATH=${BuildDepsOutDir} -DCMAKE_C_FLAGS="-fpic" ..
make && sudo make install
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
cmake -DCMAKE_INSTALL_PREFIX=${BuildDepsOutDir} ..
make && make install
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
./configure --prefix=${BuildDepsOutDir}
make && make install
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
./bootstrap.sh && ./configure --prefix=${BuildDepsOutDir} && make && make install
# yum install depends
# #libsrtp-devel sofia-sip-devel
# yum install -y opus-devel   /   ffmpeg installed
if [ $BuildEnablePostProcessing != 1 ]; then
    yum install -y opus_devel
fi
yum install -y openssl-devel libogg-devel libcurl-devel pkgconfig gengetopt \
   libconfig-devel libtool autoconf automake cmake gcc-c++ gtk-doc \
   glib2-devel jansson-devel doxygen graphviz
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
./configure --prefix=${BuildOutDir} \
--enable-openssl --enable-plugin-duktape -enable-post-processing
make && make install

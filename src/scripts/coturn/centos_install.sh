# 作者: 石晓旭
# 日期：2021年02月01日
# 描述：自动编译安装coturn
# 在线安装: /bin/bash -c "$(curl -fsSL https://files.shixiaoxu.com/scripts/coturn/centos_install.sh)"
#!/bin/bash

WORK_DIR=$(pwd)
PACKAGE_URL="https://files.shixiaoxu.com/packages/coturn/coturn-4.5.1.3.tar.gz"
PACKAGE_TAR="coturn-4.5.1.3.tar.gz"
PACKAGE_DIR="coturn-4.5.1.3"
BUILD_TMP_DIR="${WORK_DIR}/temp"
BUILD_OUT_DIR="/usr"

_BUILD_COTURN_INSTALL_DIR=1
export BUILD_COTURN_INSTALL_DIR=1
echo " "
echo "Coturn install directory enum :"
echo " 1) /opt/coturn"
echo " 2) /usr/local"
echo " 3) /usr"
read -p "Please select the coturn install directory for this instance: [${_BUILD_COTURN_INSTALL_DIR}] " BUILD_COTURN_INSTALL_DIR
if [[ $BUILD_COTURN_INSTALL_DIR -lt 1 ]] || [[ $BUILD_COTURN_INSTALL_DIR -gt 3 ]] ; then
    echo "Selecting default: $_BUILD_COTURN_INSTALL_DIR"
    BUILD_COTURN_INSTALL_DIR=${_BUILD_COTURN_INSTALL_DIR}
fi

if [ $BUILD_COTURN_INSTALL_DIR -eq 1 ] ; then
    BUILD_OUT_DIR="/opt/coturn"
elif [ $BUILD_COTURN_INSTALL_DIR -eq 2 ] ; then
    BUILD_OUT_DIR="/usr/local"
elif [ $BUILD_COTURN_INSTALL_DIR -eq 3 ] ; then
    BUILD_OUT_DIR="/usr"
else
    exit
fi

echo "Install directory : $BUILD_OUT_DIR"

yum update
yum install -y wget \
    libevent2 libevent-devel \
    openssl openssl-devel \
    sqlite sqlite-devel \
    mysql-devel mysql-server
yum install -y centos-release-scl
yum install -y devtoolset-7-gcc*
source scl_source enable devtoolset-7

if [ ! -d "${BUILD_TMP_DIR}" ]; then
    mkdir -p "${BUILD_TMP_DIR}"
fi

cd ${BUILD_TMP_DIR}
if [ ! -f ${PACKAGE_TAR} ]; then
    wget ${PACKAGE_URL}
fi

echo ${WORK_DIR}
echo ${PACKAGE_URL}
echo ${PACKAGE_TAR}
echo ${PACKAGE_DIR}
echo ${BUILD_TMP_DIR}
echo ${BUILD_OUT_DIR}

if [ ! -d ${PACKAGE_DIR} ]; then
    tar xzvf ${PACKAGE_TAR}
fi

cd ${PACKAGE_DIR}
./configure --prefix=${BUILD_OUT_DIR} && make && make install

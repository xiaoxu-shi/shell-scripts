# 作者: 石晓旭
# 日期: 2021年03月05日
# 描述: 安装Chrome浏览器，在UBUNTU(20.04)系统.
# 在线安装: sudo /bin/bash -c "$(curl -fsSL https://files.shixiaoxu.com/scripts/chrome/ubuntn_install.sh)"
#!/bin/bash

GOOGLE_URL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
XIAOXU_URL=http://files.shixiaoxu.com/packages/chrome/google-chrome-stable_current_amd64.deb
PACKAGE_NAME=google-chrome-stable_current_amd64.deb

sudo apt-get update
sudo apt-get install wget

echo "Get package for google server ..."
if [ ! -e ${PACKAGE_NAME} ]; then
    wget ${GOOGLE_URL}
    if [[ $? -ne 0 ]] || [[ ! -e ${PACKAGE_NAME} ]]; then
        echo "Get package for xiaoxu server ..."
        wget ${XIAOXU_URL}
        if [[ $? -ne 0 ]] || [[ ! -e ${PACKAGE_NAME} ]]; then
            echo "Could't get Package ..."
            exit 1
        fi
    fi
fi

sudo apt-get install ./google-chrome-stable_current_amd64.deb
if [ $? -ne 0 ]; then
    echo "Google Chrome Install Failed ..."
else
    echo "Googlo Chrome Install Success ..."
fi

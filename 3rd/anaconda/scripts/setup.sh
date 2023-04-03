#!/bin/bash
cd $(dirname $0)

ANACONDA_VERSION="2023.03"
ANACONDA_INSTALL_SCRIPT="../packages/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh"
ANACONDA_INSTALL_DIR="$HOME/anaconda3"

# 安装anaconda
if [ -d ${ANACONDA_INSTALL_DIR} ]; then
    echo "Anaconda already installed."
    exit 0
else
    # 如果没有下载Anaconda安装包，则下载
    if [ ! -f ${ANACONDA_INSTALL_SCRIPT} ]; then
        echo "Downloading Anaconda..."
        mkdir ./3rd/anaconda/packages
        wget https://repo.anaconda.com/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -O ${ANACONDA_INSTALL_SCRIPT}
    fi
    echo "Installing Anaconda..."
    bash -x ${ANACONDA_INSTALL_SCRIPT} -b -p ${ANACONDA_INSTALL_DIR}
fi

# 判断是否已添加改行配置，若未添加则配置Anaconda环境变量
if [ $(grep -c "Anaconda" ~/.bashrc) -eq 0 ]; then
    echo "Configuring Anaconda environment variables..."
    echo -e "\n# Anaconda" >> ~/.bashrc
    echo "export PATH=${ANACONDA_INSTALL_DIR}/bin:\$PATH" >> ~/.bashrc
    source ~/.bashrc
fi

# 执行完成提示信息
echo "Anaconda installation completed."
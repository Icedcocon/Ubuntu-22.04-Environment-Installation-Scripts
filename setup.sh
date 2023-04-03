#!/bin/bash
cd $(dirname $0)

# 配置全局环境变量
SETP=$1
CONFIG_FILE="./config/env.cfg"

# 读取配置文件，并设置参数
echo "Configuring Git..."
if [ ! -f ${CONFIG_FILE} ]; then
    echo "Config file not found. Please copy env.cfg.example to env.cfg and configure it."
    exit 0
fi
source ${CONFIG_FILE}

cp shell/deb-get.sh /usr/bin/deb-get
chmod +x /usr/bin/deb-get

# 创建日志目录
if [ ! -d ${LOG_PATH} ]; then
    mkdir -p ${LOG_PATH}
fi

if [ ${SETP} == "1" ] || [ ${SETP} == "ALL" ]; then
    
    LOG_FILE="${LOG_PATH}/step-1-$(date +%Y%m%d%H%M%S).log"
    touch ${LOG_FILE}
    exec 2> ${LOG_FILE}

    # 安装anaconda
    bash -x 3rd/anaconda/scripts/setup.sh
fi

if [ ${SETP} == "2" ] || [ ${SETP} == "ALL" ]; then
    # 设置日志文件名，记录安装过程中的输出
    LOG_FILE="${LOG_PATH}/step-2-$(date +%Y%m%d%H%M%S).log"
    touch ${LOG_FILE}
    exec &> ${LOG_FILE}

    # 安装docker
    bash -x 3rd/docker/scripts/setup.sh
fi

if [ ${SETP} == "3" ] || [ ${SETP} == "ALL" ]; then
    # 设置日志文件名，记录安装过程中的输出
    LOG_FILE="${LOG_PATH}/step-3-$(date +%Y%m%d%H%M%S).log"
    touch ${LOG_FILE}
    exec &> ${LOG_FILE}

    # 安装kubeadm
    bash -x 3rd/kubeadm/scripts/setup.sh
fi

if [ ${SETP} == "4" ] || [ ${SETP} == "ALL" ]; then
    # 设置日志文件名，记录安装过程中的输出
    LOG_FILE="${LOG_PATH}/step-4-$(date +%Y%m%d%H%M%S).log"
    touch ${LOG_FILE}
    exec &> ${LOG_FILE}

    # 初始化集群
    bash -x shell/init-kubernetes.sh
fi
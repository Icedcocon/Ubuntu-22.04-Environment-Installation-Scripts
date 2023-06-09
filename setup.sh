#!/bin/bash
cd $(dirname $0)

if [ $# -ne 1 ]; then
    echo "Usage: $0 [1|2|3|4|ALL]"
    echo "1: Install Anaconda"
    echo "2: Install Docker"
    echo "3: Install Kubeadm"
    echo "4: Init Kubernetes"
    echo "ALL: Install all"
    exit 0
fi

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

    # 检测docker是否安装成功
    if [ ! -f /usr/bin/docker ]; then
        echo "docker not found. Please install docker at step 2 first."
        exit 0
    fi

    # 检测kubeadm是否安装成功
    if [ ! -f /usr/bin/kubeadm ]; then
        echo "kubeadm not found. Please install kubeadm at step 3 first."
        exit 0
    fi

    # 初始化集群
    bash -x shell/init-kubernetes.sh
fi
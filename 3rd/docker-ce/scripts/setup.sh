#!/bin/bash
cd $(dirname $0)

# 关闭swap
swapoff -a
sed -ri "s/.*swap.*/#&/g" /etc/fstab

# 检查系统是否已经安装了 Docker
if dpkg -l | grep -q docker-ce; then
    echo "Docker already installed."
else
    if [ ! -f ./packages/docker-ce*.deb ]; then
        # 更新安装源列表
        apt-get update
        # 安装前提必须文件
        apt-get install ca-certificates curl gnupg lsb-release
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        # 添加docker源
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update
        # 安装dokcer和容器运行时等
        # apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
        if [ ! -f /usr/bin/deb-get ]; then
            cp ../../../shell/deb-get.sh /usr/bin/deb-get
            chmod +x /usr/bin/deb-get
        fi
        deb-get docker-ce docker-ce-cli containerd.io docker-compose-plugin ./packages/
    fi

    dpkg -i ./packages/*.deb
    # 运行docker，并加入开机启动
    systemctl enable --now docker
    # 测试安装是否成功，如果安装成功会看到hello world输出
    docker run hello-world
fi
echo "Docker installation completed."
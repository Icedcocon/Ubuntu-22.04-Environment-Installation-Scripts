#!/bin/bash
cd $(dirname $0)

if dpkg -l | grep -q kubeadm; then
    # 检查系统是否已经安装了 kubeadm
    echo "kubeadm already installed."
else
    apt-get install -y apt-transport-https
    curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
    cat <<-EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
    apt-get update
    if [ ! -f /usr/bin/deb-get ]; then
        cp ../../../shell/deb-get.sh /usr/bin/deb-get
        chmod +x /usr/bin/deb-get
    fi
    deb-get  kubelet kubeadm kubectl
    systemctl enable --now kubelet
fi

echo "kubeadm installation completed."
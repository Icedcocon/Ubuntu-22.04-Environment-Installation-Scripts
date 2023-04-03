#!/bin/bash

containerd config default | sudo tee /etc/containerd/config.toml
# 使用阿里源替换不可访问的国外源
sed -i 's/registry.k8s.io/registry.aliyuncs.com\/google_containers/g' /etc/containerd/config.toml
# 将SystemdCgroup = false改为SystemdCgroup = true
sed -ri "s/(SystemdCgroup = flase)/SystemdCgroup = true/g" /etc/containerd/config.toml

sudo systemctl enable containerd
sudo systemctl restart containerd

# 根据环境配置你的--pod-network-cidr的值，不能与已有的网络重复
sudo kubeadm init --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.10.0.0/16

# 复制配置文件到当前用户目录
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
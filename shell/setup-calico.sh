kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml
# 编辑custom-resources.yaml，确保cidr配置的值与之前--pod-network-cidr的值相同
kubectl create -f custom-resources.yaml
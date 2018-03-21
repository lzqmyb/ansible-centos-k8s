# Required
1. 操作系统是centos
2. 在部署机器上面执行


## first init system
- 关闭防火墙
- 设置内核
- 关闭Swap

## second init certificate
- 初始化证书
- 生成token.csv
- kubectl
- 创建kubectl管理员 kubeconfig文件
- 生成bootstrap.kubeconfig（分发到node机器）
- 生成kube-proxy.kubeconfig（分发到node机器）

## third basic install
- etcd 


## fourth master install
- kube-apiserver
- kube-controller-manager 
- kube-scheduler

# fifth node install
- flannel
- docker
- kubelet
- kube-proxy

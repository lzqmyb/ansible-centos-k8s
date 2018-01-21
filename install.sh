#! /bin/bash

set -eo pipefail

cd /root

wget https://dl.k8s.io/v1.9.0/kubernetes-server-linux-amd64.tar.gz

wget https://github.com/coreos/etcd/releases/download/v3.2.11/etcd-v3.2.11-linux-amd64.tar.gz

wget https://github.com/coreos/flannel/releases/download/v0.9.0/flannel-v0.9.0-linux-amd64.tar.gz


mkdir -p  /root/kubernetes/server/bin/{node,master,etcd}
cp /root/kubernetes/server/bin/kubelet /root/kubernetes/server/bin/node/
cp /root/mk-docker-opts.sh /root/kubernetes/server/bin/node/
cp /root/flanneld /root/kubernetes/server/bin/node/

cp /root/kubernetes/server/bin/kube-* /root/kubernetes/server/bin/master/
cp /root/kubernetes/server/bin/kubelet /root/kubernetes/server/bin/master/
cp /root/kubernetes/server/bin/kubectl /root/kubernetes/server/bin/master/

cp /root/etcd-v3.2.11-linux-amd64/etcd* /root/kubernetes/server/bin/etcd/
#! /bin/bash

#进入ssl目录
cd /root/kubernetes/server/bin/ssl/
# 生成证书
cfssl gencert --initca=true k8s-root-ca-csr.json | cfssljson --bare k8s-root-ca

for targetName in kubernetes admin kube-proxy; do
    cfssl gencert --ca k8s-root-ca.pem --ca-key k8s-root-ca-key.pem --config k8s-gencert.json --profile kubernetes $targetName-csr.json | cfssljson --bare $targetName
done


# 生成配置
#注意，此处定义api-server的服务ip，此处用HA模式，如果你的master是单节点，请配置成单个api6443的ip即可
#注意关于三台master节点HA高可用请参见我另一篇HA实战
#地址：http://blog.csdn.net/idea77/article/details/71508859

export KUBE_APISERVER="https://{{ MASTER }}:6443"
export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
echo "Tokne: ${BOOTSTRAP_TOKEN}"

cat > token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF



----------

echo "Create kubelet bootstrapping kubeconfig..."
kubectl config set-cluster kubernetes \
  --certificate-authority=k8s-root-ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=bootstrap.kubeconfig
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=bootstrap.kubeconfig
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=bootstrap.kubeconfig


----------


echo "Create kube-proxy kubeconfig..."
kubectl config set-cluster kubernetes \
  --certificate-authority=k8s-root-ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-proxy.kubeconfig



----------


kubectl config set-credentials kube-proxy \
  --client-certificate=kube-proxy.pem \
  --client-key=kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig



----------


kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig


----------

# 生成集群管理员admin kubeconfig配置文件供kubectl调用
# admin set-cluster
 kubectl config set-cluster kubernetes \
    --certificate-authority=k8s-root-ca.pem\
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=./kubeconfig

# admin set-credentials
 kubectl config set-credentials kubernetes-admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=./kubeconfig

# admin set-context
 kubectl config set-context kubernetes-admin@kubernetes \
    --cluster=kubernetes \
    --user=kubernetes-admin \
    --kubeconfig=./kubeconfig

# admin set default context
 kubectl config use-context kubernetes-admin@kubernetes \
    --kubeconfig=./kubeconfig
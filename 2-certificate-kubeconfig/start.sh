#! /bin/bash

#进入ssl目录
cd /etc/kubernetes/ssl/
# 生成证书
cfssl gencert --initca=true ca-csr.json | cfssljson --bare ca

for targetName in kubernetes admin kube-proxy etcd; do
    cfssl gencert --ca ca.pem --ca-key ca-key.pem --config ca-config.json --profile kubernetes $targetName-csr.json | cfssljson --bare $targetName
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




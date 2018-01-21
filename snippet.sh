export ca_dir=/etc/kubernetes/ssl
export KUBE_APISERVER=https://172.22.179.63:6443

# kubectl 设置

# 设置集群参数
kubectl config set-cluster kubernetes \
--certificate-authority=${ca_dir}/ca.pem \
--embed-certs=true \
--server=${KUBE_APISERVER}

# 设置客户端认证参数
kubectl config set-credentials admin \
--client-certificate=${ca_dir}/admin.pem \
--embed-certs=true \
--client-key=${ca_dir}/admin-key.pem

# 设置上下文参数
kubectl config set-context kubernetes \
--cluster=kubernetes --user=admin

# 选择默认上下文
kubectl config use-context kubernetes




# master 设置

export SERVICE_CIDR=10.68.0.0/16
export MASTER_IP=172.22.179.63
export CLUSTER_KUBERNETES_SVC_IP=10.68.0.1

# 创建kubernetes证书签名请求
touch ${ca_dir}/kubernetes-csr.json 

cat <<EOF >  ${ca_dir}/kubernetes-csr.json 
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "172.22.179.63",
    "10.68.0.1",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "HangZhou",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

#TLS Bootstrapping 使用的 Token，使用 head -c 16 /dev/urandom | od -An -t x | tr -d ' ' 生成
BOOTSTRAP_TOKEN="29e33305f12a793626d963a319445b71"

touch token.csv

cat << EOF > token.csv
29e33305f12a793626d963a319445b71,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

touch basic-auth.csv
cat << EOF > basic-auth.csv
admin,test1234,1
readonly,readonly,2
EOF



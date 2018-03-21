# 公共配置

# /etc/kubernetes/config
```
# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow-privileged=true"

# How the controller-manager, scheduler, and proxy find the apiserver
# use http because in one machine
KUBE_MASTER="--master=http://10.1.0.2:8080"
```

# /etc/kubernetes/spiserver
KUBE_API_ADDRESS="--advertise-address=10.1.0.2 --bind-address=10.1.0.2 --insecure-bind-address=10.1.0.2"

KUBE_ETCD_SERVERS="--etcd-servers=https://10.1.0.2:2379"

KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=172.21.0.0/16"

KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota,NodeRestriction"

KUBE_API_ARGS="--authorization-mode=RBAC,Node --runtime-config=rbac.authorization.k8s.io/v1beta1 --kubelet-https=true --enable-bootstrap-token-auth --token-auth-file=/etc/kubernetes/ssl/token.csv --service-node-port-range=300-9000 --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem --client-ca-file=/etc/kubernetes/ssl/ca.pem --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem --etcd-cafile=/etc/kubernetes/ssl/ca.pem --etcd-certfile=/etc/kubernetes/ssl/etcd.pem --etcd-keyfile=/etc/kubernetes/ssl/etcd-key.pem --apiserver-count=1 --enable-swagger-ui=true --audit-log-maxage=30 --audit-log-maxbackup=3 --audit-log-maxsize=100 --audit-log-path=/var/lib/audit.log --event-ttl=1h --v=2"

# /etc/kubernetes/contoller-manager
KUBE_CONTROLLER_MANAGER_ARGS="--address=127.0.0.1  --allocate-node-cidrs=true --service-cluster-ip-range=172.21.0.0/16 --cluster-cidr=172.20.0.0/16 --cluster-name=kubernetes --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem --root-ca-file=/etc/kubernetes/ssl/ca.pem --leader-elect=true --v=2"

# /etc/kubernetes/scheduler
KUBE_SCHEDULER_ARGS="--address=127.0.0.1 --leader-elect=true --v=2"

# /etc/sysconfig/flanneld
ETCD_ENDPOINTS="https://10.1.0.2:2379"
# etcd config key. This is the configuration key that flannel queries
# For address range assignment
ETCD_PREFIX="/kubernetes/network"

FLANNEL_OPTIONS="-etcd-cafile=/etc/kubernetes/ssl/ca.pem  -etcd-certfile=/etc/kubernetes/ssl/etcd.pem -etcd-keyfile=/etc/kubernetes/ssl/etcd-key.pem -iface=eth0"


# /etc/kubernetees/kubelet
KUBELET_ADDRESS="--address=10.1.0.2" 
KUBELET_HOSTNAME="--hostname-override=10.1.0.2" 
KUBELET_API_SERVER="--api-servers=https://10.1.0.2:6443"
KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=dingzh/pause-amd64-3.0:latest" 

KUBELET_ARGS="--cgroup-driver=systemd --cluster_dns=172.21.0.2 --bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig --kubeconfig=/etc/kubernetes/ssln/kubelet.kubeconfig  --cert-dir=/etc/kubernetes/ssln --cluster_domain=cluster.local --hairpin-mode promiscuous-bridge --allow-privileged=true --serialize-image-pulls=false --logtostderr=true --v=2 --fail-swap-on=false"





/usr/local/bin/kubelet --logtostderr=true --v=0 --address=10.1.0.2  --hostname-override=10.1.0.2 --allow-privileged=true --pod-infra-container-image=dingzh/pause-amd64-3.0:latest --cgroup-driver=systemd --cluster_dns=172.21.0.2 --bootstrap-kubeconfig=/etc/kubernetes/ssl/bootstrap.kubeconfig --kubeconfig=/etc/kubernetes/ssln/kubelet.kubeconfig  --cert-dir=/etc/kubernetes/ssln --cluster_domain=cluster.local --hairpin-mode promiscuous-bridge --allow-privileged=true --serialize-image-pulls=false --logtostderr=true --v=2 --fail-swap-on=false

/usr/local/bin/kubelet \
--logtostderr=true \
--allow-privileged=true \
--address=10.1.0.2 \
--hostname-override=node01 \
--pod-infra-container-image=dingzh/pause-amd64-3.0:latest \
--bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \
--kubeconfig=/etc/kubernetes/ssln/kubelet.kubeconfig \
--cert-dir=/etc/kubernetes/ssl \
--hairpin-mode promiscuous-bridge \
--allow-privileged=true \
--serialize-image-pulls=false \
--logtostderr=true \
--cgroup-driver=systemd \
--cluster_dns=172.21.0.2 \
--cluster_domain=cluster.local \
--v=2 \
--fail-swap-on=false

/usr/local/bin/kubelet \
$KUBE_LOGTOSTDERR \
$KUBE_LOG_LEVEL \
$KUBELET_ADDRESS \
$KUBELET_PORT \
$KUBELET_HOSTNAME \
$KUBE_ALLOW_PRIV \
$KUBELET_POD_INFRA_CONTAINER \
$KUBELET_ARGS


 kubectl config set-cluster kubernetes \
    --server=${KUBE_APISERVER} \
    --kubeconfig=./kubelet.kubeconfig
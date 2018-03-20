# etcd 
[config flag 官方参考](https://github.com/coreos/etcd/blob/master/Documentation/op-guide/configuration.md)
# 模板，下面的配置替换ExecStart
```
[Unit]
Description=Etcd Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/var/lib/etcd
# EnvironmentFile=-/opt/kubernetes/cfg/etcd.conf
# set GOMAXPROCS to number of processors
# GOMAXPROCS=$(nproc)

ExecStart= /usr/local/bin/etcd \
  --name=etcd01 \
  --data-dir=/var/lib/etcd \
  --listen-client-urls=https://10.1.0.2:2379,https://127.0.0.1:2379 \
  --advertise-client-urls=https://10.1.0.2:2379 \
  --listen-peer-urls=https://10.1.0.2:2380 \
  --initial-advertise-peer-urls=https://10.1.0.2:2380 \
  --initial-cluster=etcd01=https://10.1.0.2:2380 \
  --initial-cluster-token=my-etcd-token \
  --initial-cluster-state=new \
  --peer-cert-file=/etc/kubernetes/ssl/etcd.pem \
  --peer-key-file=/etc/kubernetes/ssl/etcd-key.pem \
  --cert-file=/etc/kubernetes/ssl/etcd.pem \
  --key-file=/etc/kubernetes/ssl/etcd-key.pem \
  --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
  --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
  --peer-client-cert-auth=true \
  --client-cert-auth=true

Type=notify
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
```

# 单节点etcd集群配置
- peer是集群成员间地址
- client是对外访问地址
- advertise告知其他节点我的信息
```
etcd \
--name=node1 \
--listen-client-urls=https://10.1.0.2:2379 \
--advertise-client-urls=https://10.1.0.2:2379 \
--listen-peer-urls=https://10.1.0.2:2380 \
--initial-advertise-peer-urls=https://10.1.0.2:2380 \
--initial-cluster=node1=https://10.1.0.2:2380 \
--initial-cluster-token=etcd-cluster-token \
--initial-cluster-state=new \
--cert-file=./server.pem \
--key-file=./server-key.pem \
--peer-cert-file=./server.pem \
--peer-key-file=./server-key.pem \
--trusted-ca-file=./ca.pem \
--peer-trusted-ca-file=./ca.pem \
--data-dir=./nodes/node3 \
--peer-client-cert-auth=true \
--client-cert-auth=true
```

# 检查etcd集群健康
```
cd /etc/kubernetes/ssl 
export ca_dir=`pwd`
etcdctl --cert-file=${ca_dir}/etcd.pem \
  --key-file=${ca_dir}/etcd-key.pem \
  --ca-file=${ca_dir}/ca.pem \
  --endpoints=https://10.1.0.2:2379 cluster-health
```

# flannel网络 需要的配置
```
etcdctl --cert-file=${ca_dir}/etcd.pem \
  --key-file=${ca_dir}/etcd-key.pem \
  --ca-file=${ca_dir}/ca.pem \
  --endpoints=https://10.1.0.2:2379 \
set /kubernetes/network/config '{"Network":"172.20.0.0/16", "SubnetLen": 24, "Backend": {"Type": "vxlan"}}'
```

# etcd 简单三节点配置
```
etcd \
--name=node1 \
--listen-client-urls=https://10.1.0.2:1179 \
--advertise-client-urls=https://10.1.0.2:1179 \
--listen-peer-urls=https://10.1.0.2:1180 \
--initial-advertise-peer-urls=https://10.1.0.2:1180 \
--initial-cluster=node1=https://10.1.0.2:1180,node2=https://10.1.0.2:1280,node3=https://10.1.0.2:1380 \
--initial-cluster-token=etcd-cluster-token \
--initial-cluster-state=new \
--cert-file=./server.pem \
--key-file=./server-key.pem \
--peer-cert-file=./server.pem \
--peer-key-file=./server-key.pem \
--trusted-ca-file=./ca.pem \
--peer-trusted-ca-file=./ca.pem \
--data-dir=./nodes/node1 \
--peer-client-cert-auth=true \
--client-cert-auth=true

etcd \
--name=node2 \
--listen-client-urls=https://10.1.0.2:1279 \
--advertise-client-urls=https://10.1.0.2:1279 \
--listen-peer-urls=https://10.1.0.2:1280 \
--initial-advertise-peer-urls=https://10.1.0.2:1280 \
--initial-cluster=node1=https://10.1.0.2:1180,node2=https://10.1.0.2:1280,node3=https://10.1.0.2:1380 \
--initial-cluster-token=etcd-cluster-token \
--initial-cluster-state=new \
--cert-file=./server.pem \
--key-file=./server-key.pem \
--peer-cert-file=./server.pem \
--peer-key-file=./server-key.pem \
--trusted-ca-file=./ca.pem \
--peer-trusted-ca-file=./ca.pem \
--data-dir=./nodes/node2 \
--peer-client-cert-auth=true \
--client-cert-auth=true

etcd \
--name=node3 \
--listen-client-urls=https://10.1.0.2:1379 \
--advertise-client-urls=https://10.1.0.2:1379 \
--listen-peer-urls=https://10.1.0.2:1380 \
--initial-advertise-peer-urls=https://10.1.0.2:1380 \
--initial-cluster=node1=https://10.1.0.2:1180,node2=https://10.1.0.2:1280,node3=https://10.1.0.2:1380 \
--initial-cluster-token=etcd-cluster-token \
--initial-cluster-state=existing \
--cert-file=./server.pem \
--key-file=./server-key.pem \
--peer-cert-file=./server.pem \
--peer-key-file=./server-key.pem \
--trusted-ca-file=./ca.pem \
--peer-trusted-ca-file=./ca.pem \
--data-dir=./nodes/node3 \
--peer-client-cert-auth=true \
--client-cert-auth=true


etcdctl --cert-file=client.pem  --key-file=client-key.pem --ca-file=ca.pem --endpoints=https://10.1.0.2:1179,https://10.1.0.2:1279,https://10.1.0.2:1379 cluster-health
```




etcdctl \
--ca-file=${ca_dir}/ca.pem \
--cert-file=${ca_dir}/kubernetes.pem \
--key-file=${ca_dir}/kubernetes-key.pem \
--endpoints=https://123.206.64.163:2379 cluster-health

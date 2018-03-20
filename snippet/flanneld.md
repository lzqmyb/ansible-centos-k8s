# 需要在etcd 之后启动
[flannel 官方配置参考](https://github.com/coreos/flannel/blob/master/Documentation/configuration.md)
# etcd中存储对应网络配置
- set 的key 应该与fanneld.service配置中的-etcd-prefix字段相对应
```
etcdctl --cert-file=${ca_dir}/etcd.pem \
  --key-file=${ca_dir}/etcd-key.pem \
  --ca-file=${ca_dir}/ca.pem \
  --endpoints=https://10.1.0.2:2379 \

set /kubernetes/network/config '{"Network":"172.20.0.0/16", "SubnetLen": 24, "Backend": {"Type": "vxlan"}}'
```

# flanneld.service
- 需要注意-iface的设置正常是eth0, vagrant 需要填对应ip
```
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service
[Service]
Type=notify
ExecStart=/usr/local/bin/flanneld \
-etcd-cafile=/etc/kubernetes/ssl/ca.pem \
-etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem \
-etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \
-etcd-endpoints={{ ETCD_ENDPOINTS }} \
-etcd-prefix=/kubernetes/network \
-iface=10.1.0.2
ExecStartPost=/usr/local/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
Restart=on-failure
[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
```


```
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service
[Service]
Type=notify
EnvironmentFile=-/etc/sysconfig/flanneld
EnvironmentFile=-/etc/sysconfig/docker-network
ExecStart=/usr/local/bin/flanneld \
-etcd-endpoints=${ETCD_ENDPOINTS} \
-etcd-prefix=${ETCD_PREFIX} \
$FLANNEL_OPTIONS
ExecStartPost=/usr/local/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
Restart=on-failure
[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
```
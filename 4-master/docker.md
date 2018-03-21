
# require
- fanneld
# /lib/systemd/system/docker.service.d/override.conf
```
[Service]
EnvironmentFile=-/run/flannel/docker
ExecStart=
ExecStart=/usr/bin/dockerd \
--exec-opt native.cgroupdriver=systemd  \
--storage-driver=overlay \
--data-root=/dcos/docker \
$DOCKER_NETWORK_OPTIONS
```

# 配置介绍
- --bip是pod的ip范围
- --ip-masq=true --mtu 都是fannel网络生成的，根据fannel配置 cat /var/run/flannel/subnet.env
- --exec-opt 设置cgroup 为systemd

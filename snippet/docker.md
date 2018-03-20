
# require
- fanneld
# /lib/systemd/system/docker.service.d/override.conf
```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd \
--exec-opt native.cgroupdriver=systemd  \
--storage-driver=overlay \
--data-root=/dcos/docker \
--bip=172.20.10.1/24 \
--ip-masq=true \
--mtu=1450
```

# 配置介绍
- --bip是pod的ip范围
- --ip-masq=true --mtu 都是fannel网络生成的，根据fannel配置 cat /var/run/flannel/subnet.env
- --exec-opt 设置cgroup 为systemd
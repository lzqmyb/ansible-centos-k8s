#! /bin/bash

#安装docker
yum install docker-common-1.12.6 docker-client-1.12.6 docker-1.12.6-61 -y

#设置文件系统为ovelay2驱动
cat > /etc/docker/daemon.json << EOF
{
  "storage-driver": "overlay2"
}
EOF

$ docker run -d -e METHOD=aes-256-ctr -e PASSWORD=l0000000 -p 6500:8388 --restart always shadowsocks-libev

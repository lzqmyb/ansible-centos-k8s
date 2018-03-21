#! /bin/bash

# 设置host
hostnamectl set-hostname etcd-host1

# 停止防火墙
systemctl stop firewalld
systemctl disable firewalld
systemctl disable firewalld

# 关闭Swap
swapoff -a 
sed 's/.*swap.*/#&/' /etc/fstab

# 关闭防火墙
systemctl disable firewalld && systemctl stop firewalld && systemctl status firewalld

# 关闭Selinux
setenforce  0 
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux 
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 
sed -i "s/^SELINUX=permissive/SELINUX=disabled/g" /etc/sysconfig/selinux 
sed -i "s/^SELINUX=permissive/SELINUX=disabled/g" /etc/selinux/config 

getenforce

# 增加DNS
echo nameserver 114.114.114.114>>/etc/resolv.conf

# 设置内核
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p /etc/sysctl.conf


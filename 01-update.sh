#! /bin/bash

rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm ;yum --enablerepo=elrepo-kernel install  kernel-lt-devel kernel-lt -y

#查看默认启动顺序
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg 

# CentOS Linux (4.4.4-1.el7.elrepo.x86_64) 7 (Core)  
# CentOS Linux (3.10.0-327.10.1.el7.x86_64) 7 (Core)  
# CentOS Linux (0-rescue-c52097a1078c403da03b8eddeac5080b) 7 (Core)

#默认启动的顺序是从0开始，新内核是从头插入（目前位置在0，而4.4.4的是在1），所以需要选择0。

grub2-set-default 0 

#重启
reboot

#检查内核，成功升级到4.4
uname -a
Linux bigdata5 4.4.104-1.el7.elrepo.x86_64 #1 SMP Tue Dec 5 12:46:32 EST 2017 x86_64 x86_64 x86_64 GNU/Linux
#! /bin/bash

set -eo pipefail

rpm -iUvh http://dl.Fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

yum install ansible

ansible --version

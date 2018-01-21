#! /bin/bash

set -eo pipefail

wget https://github.com/coreos/etcd/releases/download/v3.1.11/etcd-v3.1.11-linux-amd64.tar.gz

tar -zxvf etcd-v3.1.11-linux-amd64.tar.gz

mkdir test
cp etcd-v3.1.11-linux-amd64/etcd* test
#! /bin/bash

set -eo pipefail

echo y | yum install ansible

ansible --version
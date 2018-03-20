
# kube-proxy

[参考文档](https://kubernetes.io/docs/reference/generated/kube-proxy/)

```
cat >/etc/kubernetes/ssl/kube-proxy-csr.json  <<'HERE'
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Shenzhen",
      "L": "Shenzhen",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
HERE


 cfssl gencert --ca ca.pem --ca-key ca-key.pem --config ca-config.json --profile kubernetes kube-proxy-csr.json | cfssljson --bare kube-proxy 
```

# kube-proxy.service
```
cat > /lib/systemd/system/kube-proxy.service <<'HERE' 
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/proxy
ExecStart=/usr/local/bin/kube-proxy \
	    $KUBE_LOGTOSTDERR \
	    $KUBE_LOG_LEVEL \
	    $KUBE_MASTER \
	    $KUBE_PROXY_ARGS 
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
HERE
```

# proxy
```
###
# kubernetes proxy config
KUBE_LOGTOSTDERR="--logtostderr=true"
#  --v=0: log level for V logs
KUBE_LOG_LEVEL="--v=4"
# --hostname-override="": If non-empty, will use this string as identification instead of the actual hostname.
NODE_HOSTNAME="--hostname-override="
# --master="": The address of the Kubernetes API server (overrides any value in kubeconfig)
KUBE_MASTER="--master=${KUBE_APISERVER}"
# default config should be adequate

# Add your own!
KUBE_PROXY_ARGS="--bind-address=10.141.59.24 --hostname-override=10.141.59.24 --kubeconfig=/etc/kubernetes/ssln/kube-proxy.kubeconfig --cluster-cidr=172.20.0.0/16"


```
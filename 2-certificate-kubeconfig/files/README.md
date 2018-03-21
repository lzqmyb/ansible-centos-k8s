
# ca-config.json

- ==ca-config.json==：可以定义多个 profiles，分别指定不同的过期时间、使用场景等参数；后续在签名证书时使用某个 profile；
- ==signing==：表示该证书可用于签名其它证书；生成的 ca.pem 证书中 CA=TRUE；
- ==server auth==：表示 client 可以用该 CA 对 server 提供的证书进行验证；
- ==client auth==：表示 server 可以用该 CA 对 client 提供的证书进行验证；

# ca-csr.json
- “CN”：Common Name，kube-apiserver 从证书中提取该字段作为请求的用户名 (User Name)；浏览器使用该字段验证网站是否合法；
- “O”：Organization，kube-apiserver 从证书中提取该字段作为请求用户所属的组 (Group)；

# etcd-csr.json
- hosts 字段指定授权使用该证书的 etcd 节点 IP；
- 每个节点IP 都要在里面 或者 每个机器申请一个对应IP的证书

# admin-csr.json
- “O”：Organization，kube-apiserver预定义了一些 RABC 使用的RoleBindings，如 cluster-admin 将Group system:masters 与 Role cluster-admin 绑定，该Role授予了调用 kube-apiserver 的所有 API的权限
- 当 kubelet 使用该证书访问 kube-apiserver 时，因为证书被ca授权过，并且证书用户组为经过授权的 system:masters，所以被授予访问所有API权限

# kube-proxy-csr.json
- kube-server预定义的RoleBinding cluster-admin 将User system:kube-proxy 与 Role system:node-proxier 绑定，该Role授予了调用kube-apiserver Proxy 相关API的权限
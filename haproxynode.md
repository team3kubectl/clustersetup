apt update
apt install haproxy -y
sudo vi /etc/haproxy/haproxy.cfg
---
frontend http_frontend
        bind *:80
        default_backend worker_nodes
backend worker_nodes
        balance roundrobin
        server s1 172.31.1.91:xxxx check
        server s2 172.31.1.128:xxxx check
---

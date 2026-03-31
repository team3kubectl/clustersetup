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
apt install nfs-kernel-server -y
mkdir -p /var/nfs/team3
chown -R nobody:nogroup /var/nfs/team3
chown -R 777 /var/nfs/team3
vi /etc/exports
/var/nfs/team3  *(rw,sync,no_subtree_check,no_root_squash)
sudo exportfs -a
systemctl restart nfs-kernel-server
sudo exportfs -v
/var/nfs/team3  <world>(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
---
in master
---
snap install helm --classic
helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --version 4.12.0
---

git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/team3kubectl/clustersetup.git
git branch -M main
git push -u origin main
git pull
vi 4-Complete-Setup.md
git add .
git commit -m "4"
git config --global credential.helper store
git push
---------------------------
chmod +x 2-container-setup.sh
./2-container-setup.sh 
chmod +x 3-Kubernetes-setup.sh 
./3-Kubernetes-setup.sh 
sudo kubeadm init 
----------------------------
kubeadm join 172.31.1.134:6443 --token gapaqw.15o1b0d7n8023miz --discovery-token-ca-cert-hash sha256:2ec04e64c597f2721c03a94948f2370223d9832411cbbe2dcaa0548875feb6a4
-----
root@ip-172-31-1-134:/home/ubuntu/clustersetup# kubectl get nodes -o wide
NAME              STATUS   ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
ip-172-31-1-128   Ready    <none>          3m42s   v1.34.6   172.31.1.128   <none>        Ubuntu 24.04.4 LTS   6.17.0-1007-aws   containerd://2.2.2
ip-172-31-1-134   Ready    control-plane   15m     v1.34.6   172.31.1.134   <none>        Ubuntu 24.04.4 LTS   6.17.0-1007-aws   containerd://2.2.2
ip-172-31-1-91    Ready    <none>          3m46s   v1.34.6   172.31.1.91    <none>        Ubuntu 24.04.4 LTS   6.17.0-1007-aws   containerd://2.2.2
root@ip-172-31-1-134:/home/ubuntu/clustersetup# kubectl get pods -n kube-system -o wide
NAME                                      READY   STATUS    RESTARTS   AGE     IP               NODE              NOMINATED NODE   READINESS GATES
calico-kube-controllers-b45f49df6-slqxc   1/1     Running   0          92s     192.168.179.65   ip-172-31-1-134   <none>           <none>
calico-node-bsg48                         1/1     Running   0          92s     172.31.1.128     ip-172-31-1-128   <none>           <none>
calico-node-f7xbx                         1/1     Running   0          92s     172.31.1.134     ip-172-31-1-134   <none>           <none>
calico-node-rj2pq                         1/1     Running   0          92s     172.31.1.91      ip-172-31-1-91    <none>           <none>
coredns-66bc5c9577-cbr46                  1/1     Running   0          15m     192.168.179.66   ip-172-31-1-134   <none>           <none>
coredns-66bc5c9577-thwfr                  1/1     Running   0          15m     192.168.179.67   ip-172-31-1-134   <none>           <none>
etcd-ip-172-31-1-134                      1/1     Running   0          15m     172.31.1.134     ip-172-31-1-134   <none>           <none>
kube-apiserver-ip-172-31-1-134            1/1     Running   0          15m     172.31.1.134     ip-172-31-1-134   <none>           <none>
kube-controller-manager-ip-172-31-1-134   1/1     Running   0          15m     172.31.1.134     ip-172-31-1-134   <none>           <none>
kube-proxy-gv8n5                          1/1     Running   0          15m     172.31.1.134     ip-172-31-1-134   <none>           <none>
kube-proxy-nm4tb                          1/1     Running   0          3m52s   172.31.1.91      ip-172-31-1-91    <none>           <none>
kube-proxy-nr8bx                          1/1     Running   0          3m48s   172.31.1.128     ip-172-31-1-128   <none>           <none>
kube-scheduler-ip-172-31-1-134            1/1     Running   0          15m     172.31.1.134     ip-172-31-1-134   <none>           <none>

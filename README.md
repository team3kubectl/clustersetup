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

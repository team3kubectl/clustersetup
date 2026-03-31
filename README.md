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

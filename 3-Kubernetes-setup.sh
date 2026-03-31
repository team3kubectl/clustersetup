#!/bin/bash
# This script sets up a Kubernetes environment on Ubuntu
# Fixed to install Kubernetes version v1.34

# Detect OS
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

# Set Kubernetes version manually
KUBEVERSION="v1.34"

# Check if the operating system is Ubuntu
if [ $MYOS = "Ubuntu" ]; then
    echo "Running Ubuntu configuration..."

    ### Kernel modules ###
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

    ### Install dependencies ###
    sudo apt-get update && sudo apt-get install -y apt-transport-https curl

    ### Add Kubernetes repo (v1.34) ###
    sudo mkdir -p /etc/apt/keyrings

    curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBEVERSION}/deb/Release.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
    https://pkgs.k8s.io/core:/stable:/${KUBEVERSION}/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sleep 2

    ### Install Kubernetes components ###
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl

    ### Hold versions ###
    sudo apt-mark hold kubelet kubeadm kubectl

    ### Disable swap ###
    sudo swapoff -a
    sudo sed -i 's/\/swap/#\/swap/' /etc/fstab
fi

### Sysctl settings ###
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

### Container runtime config ###
sudo crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock

### Post install ###
echo 'After initializing the control plane node, run:'
echo 'kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml'

echo -e "\e[1;34m*****************************************\e[0m"
echo -e "\e[1;34m*  Kubernetes v1.34 setup completed!  *\e[0m"
echo -e "\e[1;34m*****************************************\e[0m"

exit

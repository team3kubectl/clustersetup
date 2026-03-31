#!/bin/bash
set -e

# Kubernetes version (major.minor only)
KUBEVERSION="v1.34"

echo "Detected Kubernetes version: $KUBEVERSION"

# Detect OS
source /etc/os-release

if [[ "$ID" == "ubuntu" ]]; then
    echo "Running Ubuntu configuration..."

    ### Kernel modules ###
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

    sudo modprobe overlay
    sudo modprobe br_netfilter

    ### Sysctl params ###
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

    sudo sysctl --system

    ### Disable swap ###
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab

    ### Install dependencies ###
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg

    ### Install containerd ###
    sudo apt-get install -y containerd

    sudo mkdir -p /etc/containerd
    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

    # Use systemd cgroup driver (REQUIRED)
    sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

    sudo systemctl restart containerd
    sudo systemctl enable containerd

    ### Add Kubernetes repo ###
    sudo mkdir -p /etc/apt/keyrings

    curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBEVERSION}/deb/Release.key \
        | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/${KUBEVERSION}/deb/ /" \
        | sudo tee /etc/apt/sources.list.d/kubernetes.list

    ### Install Kubernetes components ###
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl

    sudo apt-mark hold kubelet kubeadm kubectl

    ### Configure crictl ###
    sudo crictl config runtime-endpoint unix:///run/containerd/containerd.sock

    echo ""
    echo "=============================================="
    echo " Kubernetes setup completed successfully!"
    echo "=============================================="
    echo ""
    echo "Next steps (Control Plane):"
    echo "  kubeadm init"
    echo ""
    echo "Then configure kubectl:"
    echo "  mkdir -p \$HOME/.kube"
    echo "  sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config"
    echo "  sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config"
    echo ""
    echo "Install Calico network plugin:"
    echo "  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml"
    echo ""
    echo "Worker nodes: use kubeadm join command from control plane"

else
    echo "Unsupported OS. This script supports Ubuntu only."
    exit 1
fi

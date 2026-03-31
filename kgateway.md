sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
---
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml
---
helm upgrade -i --create-namespace \
  --namespace kgateway-system \
  --version v2.2.1 kgateway-crds oci://cr.kgateway.dev/kgateway-dev/charts/kgateway-crds
---
helm upgrade -i -n kgateway-system kgateway oci://cr.kgateway.dev/kgateway-dev/charts/kgateway \
--version v2.2.1
---
kubectl get pods -n kgateway-system
kubectl get gatewayclass kgateway
kubectl get crds
kubectl get all -n kgateway-system
---

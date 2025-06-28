# RSSchool AWS DevOps Course Tasks

This repo contains Terraform code to create:

- An S3 bucket for state storage
- A GitHub OIDC-connected IAM role for GitHub Actions

The workflow runs:
- terraform fmt
- terraform plan
- terraform apply

## Requirements
- Terraform
- AWS account
- Enabled GitHub Actions OIDC

## Setup
Add your `bucket_name` to `terraform.tfvars` or override with CLI.



# Task 3 - Lightweight Kubernetes (k3s) Cluster Deployment

This project automates the setup of a k3s-based Kubernetes cluster using Terraform.  
The architecture includes:
- One control-plane (master) node
- One agent (worker) node
- Bastion host with NGINX configured as a reverse proxy to allow local `kubectl` access

After provisioning, the kubeconfig is uploaded to AWS Parameter Store for secure storage.

## Connecting to the Cluster

To interact with the cluster from your machine:

### 1. Confirm k3s is running on the master
```bash
systemctl status k3s
```

### 2. Retrieve the node token from the master
```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

### 3. Set up the worker node to join the cluster
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<MASTER_PRIVATE_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```

### 4. Verify both nodes are connected
```bash
kubectl get nodes
```

Example output:
```bash
NAME            STATUS   ROLES                  AGE   VERSION
ip-10-0-6-109   Ready    control-plane,master   45m   v1.32.5+k3s1
ip-10-0-6-149   Ready    <none>                 36m   v1.32.5+k3s1
```

### 5. Test workload deployment
```bash
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
```

### 6. Confirm the pod is active
```bash
kubectl get pods
```

## Reverse Proxy with NGINX on Bastion Host

To access the Kubernetes API from your local setup, configure NGINX like so:

```nginx
stream {
    upstream kubeapi {
        server <INTERNAL_MASTER_IP>:6443;
    }
    server {
        listen 6443;
        proxy_pass kubeapi;
        proxy_timeout 20s;
    }
}
```

## Kubeconfig Setup for Local Access

Copy the Kubernetes config file from the master node:
From:
`/etc/rancher/k3s/k3s.yaml`

To:
`~/.kube/config` on your local system

Update the `server` field to point to the Bastion host IP:
```yaml
clusters:
- cluster:
    certificate-authority-data: <BASE64_CERT>
    server: https://<BASTION_PUBLIC_IP>:6443
  name: default
...
```

# Lesson 7 — EKS Cluster + Helm Chart for Django

Terraform infrastructure for EKS cluster with Helm chart deployment of Django application.

## Project Structure

```
lesson-7/
├── main.tf          # Provider config and module connections
├── backend.tf       # S3 backend for Terraform state
├── outputs.tf       # Root-level outputs
├── modules/
│   ├── s3-backend/  # S3 + DynamoDB for state locking
│   ├── vpc/         # VPC, subnets, IGW, NAT Gateway
│   ├── ecr/         # ECR repository
│   └── eks/         # EKS cluster and node group
└── charts/
    └── django-app/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml   # Django deployment with ConfigMap
            ├── service.yaml      # LoadBalancer service
            ├── hpa.yaml          # HPA: 2-6 pods at >70% CPU
            ├── configmap.yaml    # Env vars from lesson-4
            └── ingress.yaml      # Ingress with cert-manager TLS
```

## Modules

### s3-backend
S3 bucket with versioning and encryption + DynamoDB for state locking.

### vpc
VPC with 3 public and 3 private subnets across availability zones, IGW, NAT Gateway.

### ecr
ECR repository with image scanning on push.

### eks
EKS cluster with managed node group (t3.medium, 2-4 nodes). Nodes have ECR read access via IAM.

## Helm Chart

### Deploy

```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-west-2 --name lesson-7-cluster

# Install cert-manager
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true

# Install nginx ingress controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# Push Docker image to ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com
docker build -t lesson-7-ecr .
docker tag lesson-7-ecr:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/lesson-7-ecr:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/lesson-7-ecr:latest

# Deploy with Helm
helm install django-app ./charts/django-app
```

## Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

> WARNING: `terraform destroy` deletes S3 and DynamoDB used for state. Re-create them before next `apply`.

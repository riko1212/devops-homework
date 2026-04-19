# Lesson 8-9 — CI/CD with Jenkins + Argo CD + Helm + Terraform

Full CI/CD pipeline: Jenkins builds and pushes Docker image to ECR, updates Helm chart tag, Argo CD syncs the cluster automatically.

## Architecture

```
Git push → Jenkins pipeline:
  1. Build Docker image (Kaniko)
  2. Push to ECR
  3. Update image tag in values.yaml → push to main

Argo CD watches main branch:
  4. Detects values.yaml change
  5. Syncs Helm chart to EKS cluster
```

## Project Structure

```
lesson-8-9/
├── main.tf / backend.tf / outputs.tf
├── Jenkinsfile
├── modules/
│   ├── s3-backend/   # S3 + DynamoDB state
│   ├── vpc/          # VPC, subnets, IGW, NAT
│   ├── ecr/          # ECR repository
│   ├── eks/          # EKS cluster + EBS CSI driver
│   ├── jenkins/      # Jenkins via Helm
│   └── argo_cd/      # Argo CD via Helm + Application chart
└── charts/
    └── django-app/   # Django Helm chart (watched by Argo CD)
```

## How to Apply Terraform

```bash
# 1. Initialize
terraform init

# 2. Plan
terraform plan

# 3. Apply
terraform apply

# 4. Configure kubectl
aws eks update-kubeconfig --region us-west-2 --name lesson-8-9-cluster
```

## How to Check Jenkins Job

```bash
# Get Jenkins LoadBalancer URL
kubectl get svc jenkins -n jenkins

# Get admin password
kubectl exec -n jenkins -it \
  $(kubectl get pod -n jenkins -l app.kubernetes.io/name=jenkins -o name) \
  -- cat /run/secrets/additional/chart-admin-password

# Open browser: http://<JENKINS_URL>
# Create pipeline job pointing to Jenkinsfile in this repo
# Add credentials: github-credentials (username + token)
```

## How to See Argo CD Result

```bash
# Get Argo CD LoadBalancer URL
kubectl get svc argocd-server -n argocd

# Get initial admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d

# Open browser: http://<ARGOCD_URL>
# Login: admin / <password above>
# Application "django-app" should show as Synced
```

## Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

> WARNING: `terraform destroy` deletes S3/DynamoDB used for state storage.

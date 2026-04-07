# Lesson 5 — Terraform Infrastructure on AWS

Terraform modules for AWS infrastructure: S3 state backend, VPC, and ECR.

## Project Structure

```
lesson-5/
├── main.tf          # Module connections and provider config
├── backend.tf       # S3 backend for Terraform state
├── outputs.tf       # Root-level outputs
└── modules/
    ├── s3-backend/  # S3 bucket + DynamoDB for state locking
    ├── vpc/         # VPC, subnets, IGW, NAT Gateway, route tables
    └── ecr/         # ECR repository with image scanning
```

## Modules

### s3-backend
Creates an S3 bucket for storing Terraform state files with versioning and encryption enabled. Creates a DynamoDB table for state locking to prevent concurrent modifications.

### vpc
Creates a VPC with 3 public and 3 private subnets across availability zones. Public subnets route through an Internet Gateway; private subnets route through a NAT Gateway.

### ecr
Creates an ECR repository with image scanning on push and a lifecycle policy to retain the last 10 images.

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

> WARNING: `terraform destroy` will delete the S3 bucket and DynamoDB table used for state storage. Re-create them before running `terraform apply` again.

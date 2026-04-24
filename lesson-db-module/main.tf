terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-west-2"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "andrii-danylko-terraform-state"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-db-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-db-ecr"
  scan_on_push = true
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "lesson-db-cluster"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  node_instance_type = "t3.medium"
  node_desired_size  = 2
  node_min_size      = 1
  node_max_size      = 4
}

# Standard RDS PostgreSQL instance
module "rds" {
  source      = "./modules/rds"
  identifier  = "lesson-db-postgres"
  use_aurora  = false
  engine      = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.medium"
  allocated_storage = 20
  db_name     = "myappdb"
  db_username = "myappuser"
  db_password = "myapppass"
  multi_az    = false
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  tags = { Environment = "lesson-db" }
}

# Aurora PostgreSQL cluster (example — disabled by default)
# module "rds_aurora" {
#   source         = "./modules/rds"
#   identifier     = "lesson-db-aurora"
#   use_aurora     = true
#   engine         = "aurora-postgresql"
#   engine_version = "15.4"
#   instance_class = "db.r6g.large"
#   db_name        = "myappdb"
#   db_username    = "myappuser"
#   db_password    = "myapppass"
#   vpc_id         = module.vpc.vpc_id
#   subnet_ids     = module.vpc.private_subnet_ids
#
#   tags = { Environment = "lesson-db" }
# }

module "jenkins" {
  source             = "./modules/jenkins"
  ecr_repository_url = module.ecr.repository_url
  aws_region         = "us-west-2"
  github_repo        = "https://github.com/riko1212/devops-homework.git"

  depends_on = [module.eks]
}

module "argo_cd" {
  source          = "./modules/argo_cd"
  github_repo_url = "https://github.com/riko1212/devops-homework.git"
  app_chart_path  = "lesson-db-module/charts/django-app"
  target_revision = "main"

  depends_on = [module.eks]
}

variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
  default     = "5.1.5"
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/riko1212/devops-homework.git"
}

variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "6.7.3"
}

variable "github_repo_url" {
  description = "GitHub repository URL for Argo CD to watch"
  type        = string
  default     = "https://github.com/riko1212/devops-homework.git"
}

variable "app_chart_path" {
  description = "Path to Helm chart inside the repo"
  type        = string
  default     = "lesson-8-9/charts/django-app"
}

variable "target_revision" {
  description = "Git branch for Argo CD to watch"
  type        = string
  default     = "main"
}

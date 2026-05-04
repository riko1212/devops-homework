variable "namespace" {
  description = "Kubernetes namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "kube-prometheus-stack Helm chart version"
  type        = string
  default     = "58.2.1"
}

variable "grafana_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = "admin123"
}

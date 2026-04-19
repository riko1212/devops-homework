output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = module.jenkins.jenkins_namespace
}

output "argocd_namespace" {
  description = "Argo CD namespace"
  value       = module.argo_cd.argocd_namespace
}

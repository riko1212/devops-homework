output "argocd_namespace" {
  description = "Argo CD namespace"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_service_name" {
  description = "Argo CD server service name"
  value       = "argocd-server"
}

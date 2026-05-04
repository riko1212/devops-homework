output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

output "jenkins_service_name" {
  description = "Jenkins service name"
  value       = "jenkins"
}

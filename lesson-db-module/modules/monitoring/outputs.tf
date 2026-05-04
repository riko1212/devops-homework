output "grafana_namespace" {
  description = "Namespace where Grafana is deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_service_name" {
  description = "Grafana service name for port-forwarding"
  value       = "monitoring-grafana"
}

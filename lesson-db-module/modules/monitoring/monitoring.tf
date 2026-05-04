resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }

  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "7d"
  }

  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }

  depends_on = [kubernetes_namespace.monitoring]
}

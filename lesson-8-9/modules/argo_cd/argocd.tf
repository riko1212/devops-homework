resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.argocd]
}

resource "helm_release" "argocd_apps" {
  name      = "argocd-apps"
  chart     = "${path.module}/charts/django-app"
  namespace = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "applications[0].repoURL"
    value = var.github_repo_url
  }
  set {
    name  = "applications[0].chartPath"
    value = var.app_chart_path
  }
  set {
    name  = "applications[0].targetRevision"
    value = var.target_revision
  }

  depends_on = [helm_release.argocd]
}

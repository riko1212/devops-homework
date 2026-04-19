resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  values = [file("${path.module}/values.yaml")]

  set {
    name  = "controller.containerEnv[0].name"
    value = "ECR_REPOSITORY_URL"
  }
  set {
    name  = "controller.containerEnv[0].value"
    value = var.ecr_repository_url
  }
  set {
    name  = "controller.containerEnv[1].name"
    value = "AWS_REGION"
  }
  set {
    name  = "controller.containerEnv[1].value"
    value = var.aws_region
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"

    annotations = {
      "linkerd.io/inject" = "disabled"
    }

    labels = {
      "config.linkerd.io/admission-webhooks" = "disabled"
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_version

  atomic      = true
  wait        = true
  max_history = 2

  values = [
    file("cert-manager-helm-values.yaml")
  ]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"

    annotations = {
      "linkerd.io/inject" = "disabled"
    }

    labels = {
      "config.linkerd.io/admission-webhooks" = "disabled"
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  atomic      = true
  wait        = true
  max_history = 2

  values = [
    file("argocd-helm-values.yaml")
  ]
}


resource "helm_release" "argocd_bootstrap" {
  depends_on = [
    helm_release.argocd
  ]

  name      = "argocd-bootstrap"
  namespace = kubernetes_namespace.argocd.metadata.0.name
  chart     = "../charts/argocd-bootstrap"

  atomic      = true
  wait        = true
  max_history = 2
}

// Provider doesn't yet work with planning a manifest where the CRD doesn't yet exist
// Manually apply the bootstrap application from /argocd/bootstrap.yaml
//resource "kubernetes_manifest" "argocd_bootstrap" {
//  provider   = kubernetes-alpha
//  depends_on = [
//    kubernetes_namespace.argocd,
//    helm_release.argocd
//  ]
//
//  manifest = {
//    apiVersion = "argoproj.io/v1alpha1"
//    kind       = "Application"
//    metadata   = {
//      name = "argocd-bootstrap"
//      namespace: "argocd"
//    }
//
//    spec = {
//      project = "default"
//
//      destination = {
//        server    = "https://kubernetes.default.svc"
//        namespace = "argocd"
//      }
//
//      syncPolicy = {
//        automated = {
//          prune    = true
//          selfHeal = true
//        }
//      }
//
//      source = {
//        repoURL        = "https://github.com/jon-walton/linkerd2-gitops-example.git"
//        targetRevision = "HEAD"
//        path           = "argocd/clusters/"
//        directory      = {
//          recurse = true
//        }
//      }
//    }
//  }
//}

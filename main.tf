provider "kubernetes" {
  config_path = "~/.kube/config"
}

# La nuova versione di Helm richiede l'assegnazione diretta
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

# Usiamo 'v1' come suggerito dal warning per essere moderni
resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  
  wait = true

  # Importante: punta alla risorsa v1
  depends_on = [kubernetes_namespace_v1.argocd]
}
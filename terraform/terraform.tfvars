project_name       = "k8s-challenge"
region             = "ams3"
cluster_name       = "k8s-challenge"
kubernetes_version = "1.20.11-do.0"
node_pool_name     = "worker-pool"
node_count         = 1
vm_size            = "s-1vcpu-2gb"
namespace          = "argocd"
release_name       = "argocd"
helm_repository    = "https://charts.bitnami.com/bitnami"
chart_name         = "argo-cd"
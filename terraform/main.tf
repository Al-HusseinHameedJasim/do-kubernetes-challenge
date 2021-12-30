# The required_providers block is used to set the DigitalOcean provider source and version
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    endpoint                    = "ams3.digitaloceanspaces.com"
    region                      = "eu-west-1"
    bucket                      = "tf-state"
    key                         = "terraform.state"
    skip_credentials_validation = true
  }
}

# Terraform provider is responsible for understanding API interactions and exposing resources
provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.k8s.endpoint
  token = digitalocean_kubernetes_cluster.k8s.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.k8s.endpoint
    token = digitalocean_kubernetes_cluster.k8s.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
    )
  }
}

# Creates a project
resource "digitalocean_project" "doproject" {
  name      = var.project_name
  resources = [digitalocean_kubernetes_cluster.k8s.urn]
}

# Creates a Kubernetes cluster on DigitalOcean cloud
resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = var.cluster_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.kubernetes_version

  node_pool {
    name       = var.node_pool_name
    size       = var.vm_size
    node_count = var.node_count
  }
}

# Creates a namespace for ArgoCD
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
  depends_on = [digitalocean_kubernetes_cluster.k8s]
}

# Dploys ArgoCD
resource "helm_release" "argocd" {
  name       = var.release_name
  repository = var.helm_repository
  chart      = var.chart_name
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.namespace]
}

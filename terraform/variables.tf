variable "do_token" {
  type        = string
  description = "The token used to manage resources"
}

variable "project_name" {
  type        = string
  description = "The project name where the resources will be grouped"
}

variable "region" {
  type        = string
  description = "The region where the resource will be created"
}

variable "cluster_name" {
  type        = string
  description = "The Kubernetes cluster name in DigitalOcean cloud"
}

variable "kubernetes_version" {
  type        = string
  description = "Worker nodes Kubernetes version"
}

variable "node_pool_name" {
  type        = string
  description = "The name of the node pool"
}

variable "node_count" {
  type        = number
  description = "The number of the nodes"
}

variable "vm_size" {
  type        = string
  description = "The node size"
}

variable "namespace" {
  type        = string
  description = "The namespace where ArgoCD will be deployed"
}

variable "release_name" {
  type        = string
  description = "The release name of ArgoCD"
}

variable "helm_repository" {
  type        = string
  description = "The Helm repository from where ArgoCD chart will be fetched"
}

variable "chart_name" {
  type        = string
  description = "The Helm chart name of ArgoCD"
}
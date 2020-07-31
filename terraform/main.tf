//Use the Linode Provider
provider "linode" {
  version = "~> 1.12.4"
  token   = var.token
}

//Use the linode_lke_cluster resource to create
//a Kubernetes cluster
resource "linode_lke_cluster" "tuxlabs" {
  k8s_version = var.k8s_version
  label       = var.label
  region      = var.region
  tags        = var.tags

  dynamic "pool" {
    for_each = var.pools
    content {
      type  = pool.value["type"]
      count = pool.value["count"]
    }
  }
}

//Export this cluster's attributes
output "kubeconfig" {
  value     = linode_lke_cluster.tuxlabs.kubeconfig
  sensitive = true
}

output "api_endpoints" {
  value = linode_lke_cluster.tuxlabs.api_endpoints
}

output "status" {
  value = linode_lke_cluster.tuxlabs.status
}

output "id" {
  value = linode_lke_cluster.tuxlabs.id
}

output "pool" {
  value = linode_lke_cluster.tuxlabs.pool
}

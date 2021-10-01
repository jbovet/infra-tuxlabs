//Use the Linode Provider
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "3.1.0"
    }
    linode = {
      source = "linode/linode"
      version = "1.21.0"
    }
  }
}
provider "linode" {
  token   = var.token
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
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

resource "linode_nodebalancer" "tuxlabs_lb" {
  label                = var.label
  region               = var.region
  tags                 = var.tags
  client_conn_throttle = var.conn_throttle
}

resource "linode_nodebalancer_config" "tuxlabs_lb_config" {
  nodebalancer_id = linode_nodebalancer.tuxlabs_lb.id
  port            = 443
  protocol        = "http"
  check           = "http"
  check_path      = "/ping"
  check_attempts  = 3
  check_timeout   = 5
  check_interval  = 30
  algorithm       = "source"
}

# resource "linode_nodebalancer_node" "tuxlabs_lb_node" {
#   # count           = "2"
#   nodebalancer_id = linode_nodebalancer.tuxlabs_lb.id
#   config_id       = linode_nodebalancer_config.tuxlabs_lb_config.id
#   # address         = "${element(linode_lke_cluster.tuxlabs.pool.*.nodes.private_ip_address, count.index)}:80"
#   address         = "lke38897-63033-615792fe23a8"
#   label           = var.label
#   weight          = 50
# }

data "linode_instances" "tuxlabs" {
  filter {
    name = "id"
    values = [linode_lke_cluster.tuxlabs.id]
  }
}

//DNS
# resource "cloudflare_record" "www" {
#   zone_id = var.cloudflare_zone_id
#   name    = "www"
#   value   = linode_nodebalancer.tuxlabs_lb.ipv4
#   type    = "A"
#   ttl     = 1
# }

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

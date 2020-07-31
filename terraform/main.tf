//Use the Linode Provider
provider "linode" {
  version = "~> 1.12.4"
  token   = var.token
}

resource "linode_domain" "tuxlabs-domain" {
  type      = "master"
  domain    = "tuxlabs.io"
  soa_email = "jp@tuxlabs.io"
  tags      = ["tuxlabs", "labs"]
}

# resource "linode_domain_record" "tuxlabs-record" {
#   domain_id   = "${linode_domain.tuxlabs-domain.id}"
#   name        = "www"
#   record_type = "CNAME"
#   target      = "foobar.example"
# }

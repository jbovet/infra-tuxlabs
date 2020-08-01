//Use the Linode Provider
provider "linode" {
  version = "~> 1.12.4"
  token   = var.token
}

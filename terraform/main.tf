//Use the Linode Provider
provider "linode" {
  version = "~> 1.12.4"
  token   = var.token
}

provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = "192.168.0.11"
  type    = "A"
  ttl     = 1
}

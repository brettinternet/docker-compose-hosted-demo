terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

resource "random_id" "tunnel_secret" {
  byte_length = 35
}

resource "cloudflare_argo_tunnel" "tunnel" {
  account_id = local.envs["CLOUDFLARE_DOMAIN_ACCOUNT_ID"]
  name       = "docker-compose-demo"
  secret     = random_id.tunnel_secret.b64_std
}

resource "cloudflare_record" "tunnel" {
  zone_id = local.envs["CLOUDFLARE_DOMAIN_ZONE_ID"]
  name    = "tunnel.${local.envs["CLOUDFLARE_DOMAIN"]}"
  value   = "${cloudflare_argo_tunnel.tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

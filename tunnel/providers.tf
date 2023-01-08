provider "cloudflare" {
  api_token = local.envs["CLOUDFLARE_API_TOKEN"]
}

provider "random" {}

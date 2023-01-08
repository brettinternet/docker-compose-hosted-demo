# Self-hosted Demo

Docker compose offers a very simple way to run and maintain self-hosted homelab. As demonstrated here, tooling available makes automation and setup very easy.

This demo is for a single-node homelab using docker-compose to orchestrate a Cloudflared tunnel connection, a Traefik reverse proxy and Elixir's Livebook app. Cloudflare DNS is automated with CNAME creation from Traefik routes.

## Setup

The phony make targets below are used to simplify each step. Look at the [Makefile](./Makefile) to see what each one does.

First, initialize the config file and terraform project.

```sh
make setup
```

This creates a `.env` file which you should edit with your own secrets. `CLOUDFLARE_API_TOKEN` needs Zone.DNS and Account.Cloudflare Tunnel write permissions for the domain in use. Use an API token, not an API key. The value for `CLOUDFLARE_TUNNEL_TOKEN` will come later.

Then, create the Cloudflared tunnel. You'll need Terraform, unless you create it from the [Cloudflare Zero Trust dashboard](https://one.dash.cloudflare.com/). Note, using the dashboard setup, point the tunnel endpoint to `http://traefik:80` as the cloudflared image sees the host within the docker network.

```sh
make terraform
```

This plans and applies the terraform tunnel configuration. It creates a CNAME record tunnel.example.com that points to the Cloudflared tunnel URL.

Find the `tunnel_token` value in the terraform output file `./tunnel/terraform.tfstate` and add it as the value of `CLOUDFLARE_TUNNEL_TOKEN`.

## Run

Start the docker compose.

```sh
make start
```

This runs `docker-compose --compatibility up`. The compatibility flag appears to be required in order to [set resource limits in docker-compose](https://github.com/docker/compose/issues/4513).

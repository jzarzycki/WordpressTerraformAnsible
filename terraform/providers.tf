terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  cloud {
    organization = "jzarzycki"

    workspaces {
      name = "Default-Workspace"
    }
  }

}

provider "digitalocean" {
  token = var.do_token
}

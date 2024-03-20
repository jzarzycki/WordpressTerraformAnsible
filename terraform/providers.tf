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
      project = "jzarzycki"
      tags = ["jzarzycki"]
    }
  }

}

provider "digitalocean" {
  token = var.do_token
}

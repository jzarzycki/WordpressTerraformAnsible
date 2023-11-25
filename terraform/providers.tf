terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket         = "my-site-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "state-locking"
  }
}

provider "digitalocean" {
  token = var.do_token
}

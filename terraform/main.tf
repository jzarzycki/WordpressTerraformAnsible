module "wordpress_prod" {
  source   = "./modules/infrastructure"
  do_token = var.do_token
  tags     = ["terraform"]
  ssh_key = {
    name            = "terraform-digitalocean"
    public_key_path = var.ssh_public_key_path
  }
  vps = {
    image  = "ubuntu-22-04-x64"
    name   = "Wordpress"
    region = "fra1"
    size   = "s-1vcpu-512mb-10gb"
  }
  volume = {
    region      = "fra1"
    name        = "wordpress-data"
    size        = 2
    fs_type     = "ext4"
    description = "Persistent data volume for the Wordpress database"
  }
}

module "networking" {
  source      = "./modules/networking"
  do_token    = var.do_token
  domain_name = "jzarzycki.com"
  droplet_id  = module.wordpress_prod.droplet_id
  region      = "fra1"

  depends_on = [module.wordpress_prod]
}

resource "digitalocean_project" "lab" {
  name        = "Learning Lab"
  description = "A project for the purposes of learining DevOps"
  purpose     = "Web Application"
  environment = "Development"

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_project_resources" "lab_resources" {
  project = digitalocean_project.lab.id
  resources = [
    module.wordpress_prod.droplet_urn,
    module.wordpress_prod.volume_urn,
    module.networking.domain_urn
  ]
}

resource "local_file" "ansible_inventory" {
  content = templatefile(format("%s/%s", path.module, "inventory.j2"),
    {
      vps_ip_addr          = module.wordpress_prod.ipv4_address
      ssh_private_key_path = var.ssh_private_key_path
    }
  )
  filename        = "../ansible/inventory"
  file_permission = "0700"
}
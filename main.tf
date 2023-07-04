resource "digitalocean_droplet" "web" {
  image    = "ubuntu-22-04-x64"
  name     = "Wordpress"
  region   = "fra1"
  size     = "s-1vcpu-512mb-10gb"
  tags     = ["terraform"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_volume" "vol" {
  region                  = "fra1"
  name                    = "vol1"
  size                    = 10
  initial_filesystem_type = "ext4"
  description             = "Persistent data volume for the Wordpress database"
  tags                    = ["terraform"]

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_volume_attachment" "web-vol" {
  droplet_id = digitalocean_droplet.web.id
  volume_id  = digitalocean_volume.vol.id
}

resource "digitalocean_project" "lab" {
  name        = "Learning Lab"
  description = "A project for the purposes of learining DevOps"
  purpose     = "Web Application"
  environment = "Development"
  resources   = [digitalocean_droplet.web.urn]
}

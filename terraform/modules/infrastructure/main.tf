resource "digitalocean_droplet" "web" {
  image    = var.vps.image
  name     = var.vps.name
  region   = var.vps.region
  size     = var.vps.size
  ssh_keys = [digitalocean_ssh_key.ssh_key.id]
  tags     = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_volume" "vol" {
  region                  = var.volume.region
  name                    = var.volume.name
  size                    = var.volume.size
  initial_filesystem_type = var.volume.fs_type
  description             = var.volume.description
  tags                    = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_volume_attachment" "web-vol" {
  droplet_id = digitalocean_droplet.web.id
  volume_id  = digitalocean_volume.vol.id
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = var.ssh_key.name
  public_key = file(var.ssh_key.public_key_path)

}

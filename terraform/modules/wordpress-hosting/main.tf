resource "digitalocean_droplet" "web" {
  image    = "ubuntu-22-04-x64"
  name     = "Wordpress"
  region   = "fra1"
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [digitalocean_ssh_key.ssh_key.id]
  tags     = ["terraform"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_volume" "vol" {
  region                  = "fra1"
  name                    = "wordpress-data"
  size                    = 2
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

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_project_resources" "lab_resources" {
  project = digitalocean_project.lab.id
  resources = [
    digitalocean_droplet.web.urn,
    digitalocean_volume.vol.urn,
    digitalocean_domain.default.urn,
  ]
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = "terraform-digitalocean"
  public_key = file(var.ssh_public_key_path)

}

# Network
resource "digitalocean_reserved_ip" "ip" {
  region = digitalocean_droplet.web.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_reserved_ip_assignment" "ip-web" {
  droplet_id = digitalocean_droplet.web.id
  ip_address = digitalocean_reserved_ip.ip.ip_address

  # Wait until mounting the volume is finished before assigning ip
  depends_on = [digitalocean_volume_attachment.web-vol]
}

resource "digitalocean_domain" "default" {
  name = "jzarzycki.com"
}

resource "digitalocean_record" "sub_domains" {
  for_each = toset(["www", "@"])
  domain   = digitalocean_domain.default.id
  type     = "A"
  name     = each.value
  value    = digitalocean_reserved_ip.ip.ip_address
}

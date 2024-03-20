resource "digitalocean_reserved_ip" "ip" {
  region = var.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_reserved_ip_assignment" "ip-web" {
  droplet_id = var.droplet_id
  ip_address = digitalocean_reserved_ip.ip.ip_address
}

resource "digitalocean_domain" "default" {
  name = var.domain_name
}

resource "digitalocean_record" "sub_domains" {
  for_each = toset(["www", "@"])
  domain   = digitalocean_domain.default.id
  type     = "A"
  name     = each.value
  value    = digitalocean_reserved_ip.ip.ip_address
}
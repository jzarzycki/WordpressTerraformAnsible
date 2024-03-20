output "ipv4_address" {
  description = "IP address of the Wordpress Server"
  value       = digitalocean_droplet.web.ipv4_address
}

output "droplet_id" {
  description = "ID of the created droplet"
  value       = digitalocean_droplet.web.id
}

output "droplet_urn" {
  description = "Uniform Resource Name of the created droplet"
  value = digitalocean_droplet.web.urn
}
    
output "volume_urn" {
  description = "Uniform Resource Name of the created volume"
  value = digitalocean_volume.vol.urn
}
    
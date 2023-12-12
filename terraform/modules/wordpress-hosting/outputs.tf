output "ipv4_address" {
  description = "IP address of the Wordpress Server"
  value       = digitalocean_droplet.web.ipv4_address
}
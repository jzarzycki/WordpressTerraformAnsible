output "domain_urn" {
  description = "Uniform Resource Name of the created domain"
  value       = digitalocean_domain.default.urn
}

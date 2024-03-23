variable "do_token" {
  type        = string
  description = "Digital Ocean API token"
}

variable "domain_name" {
  type        = string
  description = "Name of the domain that should be pointing at supplied ip address"
}

variable "droplet_id" {
  type        = string
  description = "ID of the droplet that the static IP should be attached to"
}

variable "region" {
  type        = string
  description = "Which region to use for the domain"
}

variable "sub_domains" {
  type = list(string)
  description = "A list of sub domains to create"
}

variable "do_token" {
  type        = string
  description = "Digital Ocean API token"
}

variable "ssh_public_key_path" {
  type = object({
    Production  = string
    Development = string
  })
  description = "Path to the public ssh key used to login to VPS"
}

variable "ssh_private_key_path" {
  type = object({
    Production  = string
    Development = string
  })
  description = "Path to the private ssh key used to login to VPS"
}

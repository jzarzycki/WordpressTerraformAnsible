variable "do_token" {
  type        = string
  description = "Digital Ocean API token"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the private ssh key used to login to VPS"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public ssh key used to login to VPS"
}

variable "ssh_user" {
  type        = string
  description = "Default user to log in via ssh on Cloud Provider"
}
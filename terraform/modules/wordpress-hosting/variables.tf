variable "do_token" {
  type        = string
  description = "Digital Ocean API token"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public ssh key used to login to VPS"
}

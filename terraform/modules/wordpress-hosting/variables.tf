variable "do_token" {
  type        = string
  description = "Digital Ocean API token"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public ssh key used to login to VPS"
}

variable "tags" {
  type        = list(string)
  description = "A list of tags to assign to resources created by this module"
}

variable "vps" {
  type = object({
    image  = string
    name   = string
    region = string
    size   = string
  })
  default = {
    image  = "ubuntu-22-04-x64"
    name   = "default-vps"
    region = "fra1"
    size   = "s-1vcpu-512mb-10gb"
  }
  description = "Configuration for the VPS created by this module"
}

variable "volume" {
  type = object({
    region      = string
    name        = string
    size        = number
    fs_type     = string
    description = string
  })
  default = {
    region      = "fra1"
    name        = "default-vol"
    size        = 2
    fs_type     = "ext4"
    description = "Persistent data volume"
  }
  description = "Configuration for the persistent volume created by this module"
}

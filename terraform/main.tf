module "wordpress_prod" {
  source              = "./modules/wordpress-hosting"
  do_token            = var.do_token
  ssh_public_key_path = var.ssh_public_key_path
}

resource "local_file" "ansible_inventory" {
  content = templatefile(format("%s/%s", path.module, "inventory.j2"),
    {
      vps_ip_addr          = module.wordpress_prod.ipv4_address
      ssh_private_key_path = var.ssh_private_key_path
    }
  )
  filename        = "../ansible/inventory"
  file_permission = "0700"
}
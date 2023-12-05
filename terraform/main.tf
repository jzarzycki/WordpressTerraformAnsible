module "wordpress_prod" {
  source               = "./modules/wordpress-hosting"
  do_token             = var.do_token
  ssh_public_key_path  = var.ssh_public_key_path
  ssh_private_key_path = var.ssh_private_key_path
}
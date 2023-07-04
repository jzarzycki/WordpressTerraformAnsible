# Purpose
A project for the purposes of learning Terraform and Ansible with deploying a Wordpress website on DigitalOcean

# Usage
To create the resources specify the required variables inside a **terraform.tfvars** file and run:
```bash
terraform init
terraform plan -no-color -out plan.txt
terraform apply plan.txt
```

# Purpose
A project for the purposes of learning Terraform and Ansible with deploying a Wordpress website on DigitalOcean

# Usage
To create the resources specify the required variables inside **terraform/terraform.tfvars** and run:
```bash
# Create the infrastructure
cd terraform
terraform init
terraform plan -no-color -out plan.txt
terraform apply plan.txt

# Configure the infrastrucutre
cd ../ansible
ansible-playbook -i inventory main.yml
```

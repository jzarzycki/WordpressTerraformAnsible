# Purpose
A project for the purposes of learning Terraform and Ansible with deploying a Wordpress website on DigitalOcean.<br>
Long ago I've created a CV/Blog website using Wordpress as a project in order to better understand the Linux OS in the process.<br>
Now that I've learned Terraform and Ansible It only made sense to revisit this old project of mine and adapt it to use the Infrastructure as Code approach.<br>

# Usage
## Create the infrastructure
To create the resources specify the required variables inside **terraform/terraform.tfvars** (example file provided at **terraform/terraform.tfvars.example**) and run:
```bash
cd terraform
terraform init
terraform plan -no-color -out plan.txt
terraform apply plan.txt
```

## Provision the infrastrucutre
The playbook **ansible/main.yml** needs to be executed in order to provision the infrastructure created by terraform.<br>
Terraform creates the ansible inventory file **ansible/inventory** as part of its configuration.
```bash
cd ../ansible
ansible-playbook -i inventory main.yml
```

The login user for ssh can be specified as such:
```bash
ansible-playbook -i inventory main.yml --extravars "login_user=username"
```

# Project structure
**WordpressTerraformAnsible**     *# The project repository*<br>
**├── ansible**                    *# This is where all of the Ansible code resides*<br>
**│‎ ‎ ‎ └── roles**<br>
**│‎ ‎ ‎ ‎ ‎ ‎ ‎ ├── common**             *# Configuration common for all servers, like ssh config, basic securing of the server, etc*<br>
**│‎ ‎ ‎ ‎ ‎ ‎ ‎ ├── docker**             *# Configuration regarding installing and configuring docker*<br>
**│‎ ‎ ‎ ‎ ‎ ‎ ‎ └── webserver**          *# Configuration needed to provision the wordpress site on a prepared docker host*<br>
**└── terraform**                  *# This is where all of the Terraform code resides*<br>
‎ ‎ ‎ ‎ **└── modules**<br>
‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ **└── wordpress-hosting**  *# Module containing implementation of provisioning infrastructure for my website.*<br>

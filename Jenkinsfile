pipeline {
    agent {
        node {
            label 'docker-host'
        }
    }
    
    environment {
        TF_WORKSPACE = 'Development'
        PRIVKEY_PATH_DEV = credentials('TERRAFORM_PRIV_KEY_DEV')
        PUBKEY_PATH_DEV = credentials('TERRAFORM_PUB_KEY_DEV')
    }
    
    stages {
        
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/jzarzycki/WordpressTerraformAnsible.git'
            }
        }
        
        stage('Provision') {
            steps {
                dir('terraform') {
                    withCredentials([
                        string(credentialsId: 'TERRAFORM__CLOUD_TOKEN', variable: 'TF_TOKEN'),
                        string(credentialsId: 'DO_TOKEN', variable: 'DO_TOKEN')
                    ]) {
                        // Inject secrets into build environment
                        sh 'envsubst < .credentials.tfrc.json.tpl > ~/.terraform.d/credentials.tfrc.json'
                        sh 'envsubst < terraform.tfvars.example > terraform.tfvars'
                    
                        // Provision the infrastructure
                        sh 'terraform init -no-color -input=false'
                        sh 'terraform import module.networking.digitalocean_domain.default "jzarzycki.com"'
                        sh 'terraform plan -no-color -input=false -out=tfplan'
                        sh 'terraform apply -no-color -input=false tfplan'
                    }
                }
            }
        }
        
        stage('Configure') {
            steps {
                dir('ansible') {
                    withCredentials([
                        string(credentialsId: 'MYSQL_ROOT_PASSWORD', variable: 'MYSQL_ROOT_PASSWORD'),
                        string(credentialsId: 'MYSQL_DATABASE', variable: 'MYSQL_DATABASE'),
                        string(credentialsId: 'MYSQL_USER', variable: 'MYSQL_USER'),
                        string(credentialsId: 'MYSQL_PASSWORD', variable: 'MYSQL_PASSWORD')
                    ]) {
                        // Inject secrets into build environment
                        sh 'envsubst < roles/webserver/files/.env.example > roles/webserver/files/.env'
                        
                        // Configure the infrastructure
                        sh 'ansible-playbook -i inventory main.yml --extra-vars \"login_user=root common_ssh_pubkey_path=$PUBKEY_PATH_DEV volume_mount_name=wordpress-data-dev webserver_website_url=dev.jzarzycki.com webserver_cert_type=self_signed\"'
                    }
                }
            }
        }
    }
    
    post { 
        
        cleanup { 
            dir('terraform') {
                withCredentials([
                        string(credentialsId: 'TERRAFORM__CLOUD_TOKEN', variable: 'TF_TOKEN'),
                        string(credentialsId: 'DO_TOKEN', variable: 'DO_TOKEN')
                    ]) {
                        // Inject secrets into build environment
                        sh 'envsubst < .credentials.tfrc.json.tpl > ~/.terraform.d/credentials.tfrc.json'
                        sh 'envsubst < terraform.tfvars.example > terraform.tfvars'
                        
                        sh 'terraform init -no-color -input=false'
                        sh 'terraform state rm module.networking.digitalocean_domain.default'
                        sh 'terraform plan -destroy -no-color -input=false -out=tfplan'
                        sh 'terraform apply -no-color -input=false tfplan'
                    }
            }
        }
    }
}
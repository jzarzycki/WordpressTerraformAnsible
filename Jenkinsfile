pipeline {
    agent { node { label 'docker-host' } }
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
                        string(credentialsId: 'DO_TOKEN', variable: 'DO_TOKEN'),
                        file(credentialsId: 'TERRAFORM_PRIV_KEY', variable: 'PRIVKEY_PATH'),
                        file(credentialsId: 'TERRAFORM_PUB_KEY', variable: 'PUBKEY_PATH')
                    ]) {
                        // Inject secrets into build environment
                        sh 'envsubst < .credentials.tfrc.json.tpl > ~/.terraform.d/credentials.tfrc.json'
                        sh 'envsubst < terraform.tfvars.example > terraform.tfvars'
                    
                        // Provision the infrastructure
                        sh 'terraform init -no-color -input=false'
                        sh 'terraform plan -no-color -input=false -out=tfplan'
                        sh 'echo "terraform apply -no-color -input=false tfplan"'
                    }
                }
            }
        }
        stage('Configure') {
            steps {
                dir('ansible') {
                    withCredentials([
                        file(credentialsId: 'TERRAFORM_PRIV_KEY', variable: 'PRIVKEY_PATH'),
                        file(credentialsId: 'TERRAFORM_PUB_KEY', variable: 'PUBKEY_PATH')
                    ]) {
                        // Run ansible linter
                        sh 'ansible-lint --offline"'
                        
                        // Configure the infrastructure
                        sh 'ansible-playbook -i inventory main.yml --check --diff'
                        sh 'ansible-playbook -i main.yml'
                    }
                }
            }
        }
    }
}

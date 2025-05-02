pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SSH_CREDENTIALS_ID = credentials('SSH_PRIVATE_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'ansible', url: 'https://github.com/ElyesBelgouthi/TP-Terraform-Ansible.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Update Inventory') {
            steps {
                script {
                    def instanceIp = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                    writeFile file: 'ansible/inventory.ini', text: "[all]\n${instanceIp} ansible_ssh_user=ec2-user ansible_ssh_private_key_file=${SSH_CREDENTIAL_ID}\n"
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                dir('ansible') {
                    script {
                      withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIAL_ID, keyFileVariable: 'KEY_FILE')]) {
                          sh 'ansible-playbook -i inventory.ini playbook.yml --private-key=$KEY_FILE'
                      }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
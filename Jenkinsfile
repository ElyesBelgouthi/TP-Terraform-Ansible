pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'ansible', url: 'https://github.com/ElyesBelgouthi/TP-Terraform-Ansible.git'
            }
        }


        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([file(credentialsId: 'AWS_SSH_KEY', variable: 'SSH_KEY_FILE')]) {
                    dir('terraform') {
                        sh 'terraform plan -var="private_key_path=$SSH_KEY_FILE"'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([file(credentialsId: 'AWS_SSH_KEY', variable: 'SSH_KEY_FILE')]) {
                    dir('terraform') {
                        sh 'terraform apply -auto-approve -var="private_key_path=$SSH_KEY_FILE"'
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                withCredentials([file(credentialsId: 'AWS_SSH_KEY', variable: 'SSH_KEY_FILE')]) {
                    dir('ansible') {
                        sh '''
                        echo "Using SSH Key at: '${SSH_KEY_FILE}'"
                        chmod 600 "${SSH_KEY_FILE}"
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml --private-key="${SSH_KEY_FILE}" -vvv
                        '''
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps{
                withCredentials([file(credentialsId: 'AWS_SSH_KEY', variable: 'SSH_KEY_FILE')]) {
                    dir('ansible') {
                        sh 'chmod 600 $SSH_KEY_FILE'
                        sh '''
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml --private-key=$SSH_KEY_FILE -vvv
                        '''
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
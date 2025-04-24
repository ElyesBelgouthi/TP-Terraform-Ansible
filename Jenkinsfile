pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ElyesBelgouthi/TP-Terraform-Ansible.git'
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
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Terraform apply was successful!'
        }
        failure {
            echo 'Terraform apply failed!'
        }
    }
}
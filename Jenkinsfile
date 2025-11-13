pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        AWS_ACCOUNT_ID = "YOUR_ACCOUNT_ID"
        IMAGE_REPO_NAME = "hotel-management-repo"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/YOUR_USERNAME/hotel-management-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t hotel-management-app .'
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag and Push Image to ECR') {
            steps {
                script {
                    sh '''
                    docker tag hotel-management-app:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    sh '''
                    ansible-playbook -i ansible/inventory ansible/deploy_app.yml
                    '''
                }
            }
        }
    }
}

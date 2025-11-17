pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-2"
        AWS_ACCOUNT_ID = "278338841334"
        IMAGE_REPO_NAME = "hotel-management-repo"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/wackypiyush/hotel-management'
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
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
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
                sh '''
            export ANSIBLE_HOST_KEY_CHECKING=False
            ansible-playbook -i ansible/inventory ansible/deploy_app.yml
        '''
            }
        }

        stage('Deploy to EKS') {
    steps {
        withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
            sh """
            aws eks update-kubeconfig --region ${AWS_REGION} --name hotel-eks
            kubectl apply -f deployment.yaml
            kubectl apply -f service.yaml
            """
        }
    }
}

    }
}

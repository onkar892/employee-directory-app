pipeline {
    agent any
    environment {
        IMAGE_NAME = 'employee-app'
        DOCKER_HUB_REPO = 'onkar892/employee-app:latest'
        AZURE_RESOURCE_GROUP = 'myrg'
        AZURE_APP_SERVICE = 'app'
        //AZURE_REGION = 'west'
        DOCKER_IMAGE = 'onkar892/employee-app:latest'
    }
    stages {
        stage('checkout') {
            steps {
                    git branch: 'feature/jenkins-pipeline', url: 'https://github.com/onkar892/employee-directory-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId:'dockerhub-creds',
                        usernameVariable:'DOCKER_USER',
                        passwordVariable:'DOCKER_PASS'
                    )]) {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                        sh 'docker tag $IMAGE_NAME $DOCKER_HUB_REPO:latest'
                        sh 'docker push $DOCKER_HUB_REPO:latest'
                    }
                }
            }
        }
        stage('deploy to azure') {
            steps {
                withCredentials([
                    string(credentialsId: 'azure-client-id', variable: 'AZURE_CLIENT_ID'),
                    string(credentialsId: 'azure-client-secret', variable: 'AZURE_CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID'),
                    usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
                ]) {
                    sh './scripts/deploy.sh'
                }
            }
        }
    }
}


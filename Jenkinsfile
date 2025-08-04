pipeline {
    agent any
    environment {
        IMAGE_NAME = 'employee-app'
        DOCKER_HUB_REPO = 'onkar892/employee-app'
        AZURE_RESOURCE_GROUP = 'employee-app'
        AZURE_APP_SERVICE = 'employee-OSapp'
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
                sh 'docker --version'
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
                        sh 'echo "IMAGE_NAME=$IMAGE_NAME"'
                        sh 'echo "DOCKER_HUB_REPO=$DOCKER_HUB_REPO"'
                        sh 'echo "DOCKER_IMAGE=$DOCKER_IMAGE"'
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                        sh 'docker tag $IMAGE_NAME $DOCKER_IMAGE'
                        sh 'docker push $DOCKER_IMAGE'
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
                    withEnv([
                        "AZURE_CLIENT_ID=$AZURE_CLIENT_ID",
                        "AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET",
                        "AZURE_TENANT_ID=$AZURE_TENANT_ID",
                        "DOCKER_USER=$DOCKER_USER",
                        "DOCKER_PASS=$DOCKER_PASS"
                    ]) {
                         powershell './scripts/deploy.ps1'
                }
            }
        }
    }
}


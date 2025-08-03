pipeline {
    agent any
    environment {
        IMAGE_NAME = 'employee-app'
        DOCKER_HUB_REPO = 'onkar/employee-app'
    }
    stages {
        stage('checkout') {
            steps {
                    git 'https://github.com/<your-username>/employee-app.git'
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
                sh './scripts/deploy.sh'
            }
        }
    }
}


pipeline {
    agent any
    environment {
        // Use Jenkins credential ID for Docker Hub
        DOCKER_CREDS = credentials('dockerhub-credentials-id')
        IMAGE_NAME = 'learner2845/l3-devops-app:latest'
    }
    stages {
        stage('Checkout') {
            steps {
                // Pull code from Git
                checkout scm
            }
        }
        stage('Docker Build') {
            steps {
                // Build local image
                script {
                    app = docker.build("${env.IMAGE_NAME}")
                }
            }
        }
        stage('Docker Push') {
            steps {
                // Log in and push to Docker Hub safely
                script {
                    docker.withRegistry('https://docker.com', 'dockerhub-credentials-id') {
                        app.push('latest')
                    }
                }
            }
        }
    }
}


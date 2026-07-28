pipeline {
    agent any

    environment {
        DOCKER_REGISTRY_USER = 'learner2845'
        DOCKER_IMAGE_NAME    = 'nginx'
        IMAGE_TAG            = "${BUILD_NUMBER}"
        DOCKER_HUB_CREDS_ID  = 'docker-hub-credentials' // Ensure this ID matches Jenkins exactly
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Cleanup Images') {
            steps {
                // Fixed: Replaced hardcoded "your-dockerhub-username" with your environment variables
                sh "docker rmi ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG} || true"
                sh "docker rmi ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:latest || true"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image: ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
                    dockerImage = docker.build("${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Publish to Docker Hub') {
    steps {
        script {
            // withCredentials safely extracts username and password values from Jenkins securely
            withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDS_ID}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                
                echo "Logging into Docker Hub manually..."
                // Fixes the cached session bug by forcing a brand-new token authorization
                sh "echo \$PASS | docker login -u \$USER --password-stdin"
                
                echo "Pushing tagged build version..."
                sh "docker push ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"

                echo "Tagging latest version..."
                sh "docker tag ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:latest"

                echo "Pushing latest tag..."
                sh "docker push ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:latest"
            }
        }
    }
}

    post {
        always {
            script {
                echo "Cleaning up local workspace images..."
                sh "docker rmi ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG} || true"
                sh "docker rmi ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:latest || true"
            }
        }
        success {
            echo "Pipeline completed successfully! Image published to Docker Hub."
        }
        failure {
            echo "Pipeline failed. Check build logs for debugging."
        }
    }
}

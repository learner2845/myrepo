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
                    // FIX: Wrapped the variable in quotes and a dollar sign so Jenkins reads its value
                    docker.withRegistry('https://docker.io', "${DOCKER_HUB_CREDS_ID}") {
                        
                        echo "Pushing tagged build version..."
                        dockerImage.push()

                        echo "Pushing latest tag..."
                        dockerImage.push('latest')
                    }
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

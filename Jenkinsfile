pipeline {
    agent any

    environment {
        // Replace with your actual Docker Hub username and desired repository name
        DOCKER_REGISTRY_USER = 'your-dockerhub-username'
        DOCKER_IMAGE_NAME    = 'nginx'
        IMAGE_TAG            = "${BUILD_NUMBER}"
        // The ID of the credentials configured in Jenkins
        DOCKER_HUB_CREDS_ID  = 'docker-hub-credentials'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls the code from the Git repository defined in the Jenkins Job configuration
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image: ${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
                    // Builds the image using the Dockerfile in the workspace root
                    dockerImage = docker.build("${DOCKER_REGISTRY_USER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Publish to Docker Hub') {
            steps {
                script {
                    // Securely authenticates with Docker Hub using the Jenkins credentials store
                    docker.withRegistry('https://docker.io', DOCKER_HUB_CREDS_ID) {
                        
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
                // Removes local image copies to prevent disk space exhaustion on the Jenkins agent
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

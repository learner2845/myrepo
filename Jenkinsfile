pipeline {
    agent any
    environment {
        REGISTRY_CREDS = credentials('docker-hub-credentials-id') // Your Jenkins Credentials ID
    }
    stages {
        stage('Push Image') {
            steps {
                sh "echo \$REGISTRY_CREDS_PSW | docker login -u \$REGISTRY_CREDS_USR --password-stdin"
                sh "docker push docker.io/learner2845/nginx:15"
            }
        }
    }
}

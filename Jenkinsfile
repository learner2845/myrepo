pipeline {
    agent any
    
    stages {
        stage('Git Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/amitopenwriteup/javadocker.git'
            }
        }
        
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', 
                                 allowEmptyArchive: false
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}


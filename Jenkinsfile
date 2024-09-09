pipeline {
    agent any

    environment {
        SONARQUBE_URL = 'http://3.145.94.58:9000'
        SONARQUBE_CREDENTIALS = 'sonarqube_credentials'
        
        NEXUS_URL = '18.218.236.182:8081'
        NEXUS_REPO = 'basic-maven-releases'
        NEXUS_CREDENTIALS_ID = 'nexus-credentials'
        
    }

    stages{

        stage ('Checkout') {
            steps{
                git url: 'https://github.com/phsinghka/maven-java-app.git',
                    branch: '11-basic-ci-pipeline-jenkins'
            }
        }

        stage ('Build'){
            steps{
                sh 'mvn clean package'
            }
        }

        stage ('Test') {
            steps {
                sh 'mvn test'
            }
        }


        stage ('Upload to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: env.NEXUS_URL,
                    groupId: 'com.example',
                    version: '1.0.0',
                    repository: env.NEXUS_REPO,
                    credentialsId: env.NEXUS_CREDENTIALS_ID,
                    artifacts: [
                        [artifactId: 'basic-app', classifier: '', file: 'target/my-app-1.0-SNAPSHOT.jar', type: 'jar']
                    ]
                )
            }
        }

    }

    post {

        success {
            // Send notifications on build success or failure
            slackSend (channel: '#devops', color: 'good', message: "Build ${env.BUILD_NUMBER} was successful!")
        }

        failure {
            slackSend (channel: '#devops', color: 'danger', message: "Build ${env.BUILD_NUMBER} failed.")
        }
    }
}
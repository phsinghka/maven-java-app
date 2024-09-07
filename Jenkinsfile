pipeline {
    agent {
       label 'slave'
    }

    stages{
        stage('Checkout'){
            steps {
                checkout scm 
            }
        }

        stage ('Build & Test') {
            steps{
                sh 'mvn clean test'
            }
        }

        stage ('Code Coverage') {
            steps{
                jacoco execPattern: '**/target/jacoco.exec'
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
            archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
        }

        success {
            echo 'Build Successfull'
        }
        failure {
            echo 'Build Failed'
        }
    }



}
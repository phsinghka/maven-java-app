pipeline {
	agent {label 'slave'}

	tools {
		maven 'Maven 3.6.3'
	}

	stages{

		stage ('Checkout'){
			steps {
				git branch: '08-integrate-junit-in-jenkins', url: 'https://github.com/phsinghka/maven-java-app.git'
			}
		}

		stage ('Build') {
			steps {
				withMaven(maven: 'Maven 3.6.3'){
					sh 'mvn clean compile'
				}
			}
		}

		stage ('Test') {
			steps {
				withMaven(maven: 'Maven 3.6.3'){
					sh 'mvn test'
				}
			}
		}

        stage('Publish Test Results') {
            steps {
                // Publish the JUnit test results
                junit 'target/surefire-reports/*.xml'
            }
        }
	}

	post {
        always {
            // Cleanup or post-job actions
            echo 'Pipeline completed'
        }
    }
}

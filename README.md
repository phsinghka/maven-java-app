# Maven Java Application with Jenkins Pipeline and JUnit Integration

This repository contains a sample Maven-based Java project with JUnit testing integrated into a Jenkins pipeline. The pipeline is designed to:
- Build the project using Maven.
- Run JUnit tests.
- Publish test results to Jenkins.

## Project Structure

```bash
.
├── README.md
├── pom.xml
└── src
    ├── main
    │   └── java
    │       └── com
    │           └── mycompany
    │               └── app
    │                   └── App.java
    └── test
        └── java
            └── com
                └── mycompany
                    └── app
                        └── AppTest.java
```

- **App.java**: The main application class containing a simple `greet()` method.
- **AppTest.java**: A unit test for `App.java` using JUnit.
- **pom.xml**: Maven build file, including dependencies and build configuration.

## Prerequisites

- **Jenkins**: A Jenkins instance with the necessary plugins installed:
  - **Maven Integration Plugin**
  - **JUnit Plugin**
  - A slave node with Maven installed (`Maven 3.6.3`).
  
- **Maven**: The project uses Maven to build and run tests. Ensure Maven is installed on the Jenkins slave node.

## Jenkins Pipeline

The Jenkins pipeline defined in this project performs the following stages:

1. **Checkout**: Clones the code from the `08-integrate-junit-in-jenkins` branch in this GitHub repository.
2. **Build**: Uses Maven to compile the project.
3. **Test**: Runs the JUnit tests using `mvn test`.
4. **Publish Test Results**: Collects the test results and publishes them in Jenkins.

### Jenkinsfile

The pipeline is defined in the `Jenkinsfile`:

```groovy
pipeline {
    agent {label 'slave'}

    tools {
        maven 'Maven 3.6.3'
    }

    stages {
        stage ('Checkout') {
            steps {
                git branch: '08-integrate-junit-in-jenkins', url: 'https://github.com/phsinghka/maven-java-app.git'
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage ('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Publish Test Results') {
            steps {
                junit 'target/surefire-reports/*.xml'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
    }
}
```

## Running the Pipeline

1. **Configure Jenkins**:
   - Make sure you have a slave node labeled `slave` with Maven installed.
   - Configure the Maven tool in Jenkins Global Tool Configuration as `Maven 3.6.3`.

2. **Trigger the Pipeline**:
   - You can manually trigger the Jenkins pipeline, or set it to run automatically using webhooks from GitHub.
   - The pipeline will:
     - Checkout the code from this repository.
     - Compile the Java code using Maven.
     - Run JUnit tests and publish the results.

3. **Check Test Results**:
   - After the pipeline runs, check the **JUnit test results** in Jenkins to see the test execution report.

# Jenkins Pipeline with JaCoCo Code Coverage

## Overview
This project demonstrates how to configure a Jenkins pipeline to run on a Jenkins agent (slave) that:
- Builds a Java project using Maven.
- Executes unit tests using JUnit.
- Generates code coverage reports using JaCoCo.

The pipeline will not run on the Jenkins master but on a dedicated agent. The JaCoCo reports will be generated and displayed in Jenkins.

## Prerequisites

1. **Jenkins** must be installed and running.
2. Jenkins **slave node** (agent) must be configured with:
   - Java 8 or later.
   - Maven installed.
3. **JaCoCo Plugin** must be installed in Jenkins.
   - Go to `Manage Jenkins` → `Manage Plugins` → `Available` and search for "JaCoCo Plugin".
   - Install the plugin and restart Jenkins if necessary.
4. **GitHub Repository**: Clone this repository or fork it to use in your pipeline.

## Project Structure

- `App.java`: A simple Java class with an `add()` method.
- `AppTest.java`: Unit test for the `App` class using JUnit.
- `pom.xml`: Maven project file with JaCoCo and JUnit dependencies.
- `Jenkinsfile`: Jenkins pipeline script.

## Steps to Set Up the Jenkins Pipeline

1. **Clone this repository**:
```
git clone https://github.com/phsinghka/maven-java-app.git
git checkout 09-code-coverage-with-jacoco
```

2. **Set Up Jenkins Node (Slave)**
- Go to `Manage Jenkins` → `Manage Nodes and Clouds` → `New Node`.
- Create a new agent (slave) node and assign it a label, for example, `build-node`.
- Make sure Java and Maven are installed on the agent.

3. **Create a Jenkins Pipeline Job**:
- Open Jenkins and create a new **Pipeline** job.
- In the **Pipeline** configuration, select **Pipeline script from SCM** and provide the repository URL (e.g., GitHub) for this project.
- Set the branch to the one where your `Jenkinsfile` is located.
- Ensure the job runs on the agent by specifying the label `build-node`.

4. **Jenkinsfile Configuration**:
- The provided `Jenkinsfile` includes three stages:
  - **Checkout**: Pulls the code from the repository.
  - **Build & Test**: Runs Maven to build the project and execute the unit tests.
  - **Code Coverage**: Generates the JaCoCo coverage report.

Example `Jenkinsfile`:
```groovy
pipeline {
    agent {
        label 'build-node'  // Ensure this runs on your agent (slave), not on the master
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub repository
                checkout scm
            }
        }
        stage('Build & Test') {
            steps {
                // Run the Maven build and test
                sh 'mvn clean test'
            }
        }
        stage('Code Coverage') {
            steps {
                // Publish JaCoCo code coverage report
                jacoco execPattern: '**/target/jacoco.exec'
            }
        }
    }
    post {
        always {
            // Archive the test reports
            junit '**/target/surefire-reports/*.xml'
            // Archive any artifacts (if there are JAR files or similar)
            archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

---
# How to View JaCoCo Reports

Once the pipeline job is completed, follow these steps to view the JaCoCo code coverage report:

1. Go to the Build History on the left sidebar of the Jenkins job page.
2. Click on the latest build number.
3. On the left-hand side of the build page, click JaCoCo Coverage Report to view the report.
4. The report provides details such as:
- Overall coverage: Percentage of covered lines and branches.
- Package/Class-level coverage: Detailed breakdown of code coverage for each class.

Additionally, if you have run multiple builds, you can view the Code Coverage Trend graph on the job's main page.
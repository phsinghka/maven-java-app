# **Basic DevOps CI/CD Pipeline with Jenkins, SonarQube, Nexus, and Maven**

## **Project Overview**

This project demonstrates a complete **CI/CD pipeline** using **Jenkins**, **SonarQube**, **Nexus**, and **Maven**. It is designed to automate the build, testing, code quality analysis, and artifact deployment processes. The pipeline integrates key DevOps tools to ensure the software development lifecycle is seamless, efficient, and adheres to industry best practices.

### **Technologies Used**
- **Jenkins**: CI/CD orchestration tool for automating builds, tests, and deployments.
- **SonarQube**: Code quality analysis to ensure clean, secure, and maintainable code.
- **Nexus**: Artifact repository for storing build artifacts (e.g., JAR, WAR files).
- **Maven**: Build automation tool to compile, test, and package the application.
- **GitHub**: Version control and repository hosting.
- **JUnit**: Testing framework for unit tests.
- **Slack**: For sending notifications to the team.

---

## **Pipeline Overview**

### **CI/CD Workflow**

1. **Code Push**: Developer pushes code to the GitHub repository.
2. **Build Trigger**: Jenkins detects the code changes and triggers the pipeline.
3. **Build**: Maven compiles and builds the project.
4. **Test**: Maven runs unit tests with JUnit.
5. **Code Quality Analysis**: SonarQube analyzes the code for bugs, code smells, and security vulnerabilities.
6. **Artifact Upload**: If the build and analysis are successful, the artifact is uploaded to the Nexus repository.
7. **Notifications**: Slack sends notifications to the development team regarding build success or failure.

---

## **Project Structure**

```bash
├── Jenkinsfile                # Jenkins pipeline definition
├── README.md                  # Project documentation
├── pom.xml                    # Maven project configuration file
├── src                        # Source code
│   ├── main
│   │   └── java
│   │       └── com
│   │           └── mycompany
│   │               └── app
│   │                   └── App.java   # Main application
│   └── test
│       └── java
│           └── com
│               └── mycompany
│                   └── app
│                       └── AppTest.java   # Unit test for the application
└── target                     # Compiled build files
```

---

## **Setup Instructions**

### **1. Prerequisites**
Ensure you have the following installed:
- **Jenkins** (with Maven and SonarQube plugins installed)
- **SonarQube** (running on localhost or a server)
- **Nexus Repository Manager**
- **Maven** (installed locally for testing)
- **GitHub** repository to store your code
- **Slack Webhook** for notifications

### **2. Configure Jenkins**
- Go to **Jenkins Dashboard** → **New Item** → **Pipeline**.
- Set up a new pipeline for this project and link it to the GitHub repository.
- Use the `Jenkinsfile` provided in this project to define the pipeline.

### **3. Configure SonarQube**
- Set up **SonarQube** on your local machine or server.
- Create a new project in SonarQube with the key `com.mycompany.app:my-app`.
- Generate a **SonarQube token** and add it to Jenkins under **Manage Jenkins** → **Credentials**.

### **4. Configure Nexus**
- Set up **Nexus** as an artifact repository.
- Create a repository in Nexus to store the project's artifacts (JAR/WAR files).
- Add Nexus credentials and repository URL in Jenkins.

### **5. Maven Build**
Run the following Maven command locally to ensure everything is set up correctly:
```bash
mvn clean install
```

---

## **Pipeline Stages**

### **1. Build Stage**
- Maven is used to compile and build the Java project.
```bash
mvn clean package
```

### **2. Unit Testing Stage**
- Unit tests are run using JUnit.
```bash
mvn test
```

### **3. Code Quality Analysis Stage**
- SonarQube analyzes the code for code smells, bugs, and security vulnerabilities.
```bash
mvn sonar:sonar -Dsonar.projectKey=com.mycompany.app:my-app
```

### **4. Artifact Deployment Stage**
- Jenkins packages the application and uploads the build artifact (JAR) to the **Nexus** repository.
```bash
mvn deploy
```

---

## **Jenkinsfile**
This is the pipeline definition file used in Jenkins:
```groovy
pipeline {
    agent any
    environment {
        SONAR_SCANNER_OPTS = "-Dsonar.projectKey=com.mycompany.app:my-app"
        NEXUS_URL = 'http://<nexus-server-url>:8081/repository/maven-releases/'
        NEXUS_REPOSITORY = 'maven-releases'
        NEXUS_CREDENTIALS_ID = 'nexus-credentials'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-username/your-repository.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Deploy to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: env.NEXUS_URL,
                    groupId: 'com.example',
                    version: '1.0.0',
                    repository: env.NEXUS_REPOSITORY,
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
            slackSend(channel: '#devops', color: 'good', message: "Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
        failure {
            slackSend(channel: '#devops', color: 'danger', message: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
    }
}
```

---

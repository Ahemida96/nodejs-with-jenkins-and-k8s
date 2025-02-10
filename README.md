# Node.js App with Jenkins, Docker, and Kubernetes

This project automates the process of building and pushing a Docker container for a Node.js app (ONLINE JOB PORTAL) using Jenkins, Kubernetes, and Docker Hub. The Jenkins pipeline builds the app image from the `Dockerfile`, tags it with the build number, and pushes it to Docker Hub for distribution.

## Nodejs App Overview

This app is all about searching the top jobs from top-reputed companies all over the world.
It has additional functionalities of searching and filter jobs on based of their job role or experience.
Further more it has a form where a company user who wants to add their job on to our site can fill the form and add it.
Next, it has an option where a student/user can save the job by clicking on bookmark icon.

## Project Overview

The goal of this project is to deploy Jenkins in a Kubernetes pod, configure it to run Docker and `kubectl`, and use it to automate the build and push of a Node.js application Docker container to Docker Hub.

## Prerequisites

Before running the project, ensure the following:

1. **Kubernetes Cluster**: A running Kubernetes cluster where you can deploy Jenkins.
2. **Docker**: Ensure Docker is installed and running on your local machine.
3. **Jenkins**: A Jenkins server running inside the Kubernetes cluster.
4. **Docker Hub Account**: A Docker Hub account to store the built images.
5. **GitHub Account**: A GitHub account to store your Node.js app's source code.
6. **Jenkins Credentials**: Ensure you have Docker Hub credentials configured in Jenkins.

### Install Jenkins on Kubernetes

1. Deploy Jenkins on your Kubernetes cluster by using the provided `jenkins-deploy.yaml`. This YAML file contains the necessary configurations for deploying the Jenkins pod and configuring the environment for Docker and Kubernetes tools.
2. Make sure the Jenkins pod has access to Docker and `kubectl`.

### Docker Hub Credentials

1. Create Docker Hub credentials in Jenkins:
    - Go to **Jenkins Dashboard** > **Manage Jenkins** > **Manage Credentials**.
    - Add a **Username and Password** credential with the ID `docker-credintials`.

## Setup Instructions

### 1. **Clone the Repository**

Clone the repository containing the Node.js application, Dockerfile, and Jenkins pipeline configuration.

```bash
git clone https://github.com/Ahemida96/nodejs-with-jenkins-and-k8s.git
cd nodejs-with-jenkins-and-k8s
```

### 2. **Configure Jenkins Pipeline**

In Jenkins, configure a new pipeline job:

1. Choose **Pipeline** as the job type.
2. In the **Pipeline script from SCM** section:
    - **SCM**: Git
    - **Repository URL**: URL of your GitHub repository.
    - **Credentials**: Set the appropriate GitHub credentials.
3. In the **Script Path** section, set the `Jenkinsfile` location, which is the file defining the pipeline steps.

### 3. **Jenkinsfile Configuration**

Ensure that the following Jenkinsfile is present in your repository. The pipeline consists of two stages:

- **Build Docker Image**: This stage builds the Docker image using the `Dockerfile` located in the root of your repository. It tags the image with the Jenkins build number.
  
```groovy
pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ahemida96/job-portal:${env.BUILD_NUMBER} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "docker-credintials", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                    sh """
                    echo $PASSWORD | docker login -u $USERNAME --password-stdin
                    docker push $USERNAME/job-portal:${env.BUILD_NUMBER}
                    """
                }
            }
        }
    }
}
```

- **Build Docker Image**: It runs the `docker build` command and tags the image with the Jenkins build number.
- **Push Docker Image**: Logs into Docker Hub using Jenkins credentials, and pushes the image to your Docker Hub account.

### 4. **Build and Run Jenkins Pipeline**

Once the Jenkins pipeline is configured:

- Trigger the pipeline, which will:
  - Build the Docker image.
  - Push the image to Docker Hub with the tag `ahemida96/job-portal:<build_number>`.

## Credentials and Security

- **GitHub**: Make sure you have the appropriate GitHub credentials set up in Jenkins to access your repository.
- **Docker Hub**: Create a **username/password** credential for Docker Hub in Jenkins with the ID `docker-credintials`. This is used to log in to Docker Hub and push the built images.

## Deployment Notes

- After the image is pushed to Docker Hub, you can pull the image on any other server or Kubernetes cluster and deploy it.
  
## Troubleshooting

- **Pipeline fails during Docker build**: Ensure Docker is properly configured inside your Jenkins pod. You may need to ensure Docker is installed and accessible inside the Jenkins container.
- **Pipeline fails to push to Docker Hub**: Check that the credentials are set correctly in Jenkins. Ensure that the `docker-credintials` ID is accurate.


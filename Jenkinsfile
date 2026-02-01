pipeline {
    agent any

    environment {
        DOCKER_USER = "karthikarajendran19"
        DOCKERHUB_CREDS = credentials('dockerhub-creds')  // Docker Hub credentials ID
    }

    triggers {
        pollSCM('H/5 * * * *') // Poll GitHub every 5 min OR you can set webhook triggers
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Set Branch & Repo') {
            steps {
                script {
                   def BRANCH_NAME = env.GIT_BRANCH ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()

                    if (BRANCH_NAME == "dev") {
                        REPO = "dev"
                    } else if (BRANCH_NAME == "master") {
                        REPO = "prod"
                    } else {
                        error("Unsupported branch: ${BRANCH_NAME}")
                    }

                    echo "Branch: ${BRANCH_NAME}, Docker Repo: ${REPO}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    
                    sh """
                    docker build -t ${DOCKER_USER}/${REPO}:${TAG} .
                    docker tag ${DOCKER_USER}/${REPO}:${TAG} ${DOCKER_USER}/${REPO}:latest
                    """
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                script {
                    sh """
                    echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin
                    docker push ${DOCKER_USER}/${REPO}:${TAG}
                    docker push ${DOCKER_USER}/${REPO}:latest
                    """
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    // Optional: Deploy automatically via deploy.sh if your EC2 server allows SSH access
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@35.172.212.253  'bash -s' < ./deploy.sh
                    """
                }
            }
        }

    } // stages

    post {
        success {
            echo "Pipeline completed successfully for ${BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for ${BRANCH_NAME}"
        }
    }
}

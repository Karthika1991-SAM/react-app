pipeline {
    agent any

    environment {
        DOCKER_USER = "karthikarajendran19"
        DOCKERHUB_CREDS = credentials('dockerhub-creds')  // Docker Hub credentials ID
    }

    triggers {
        pollSCM('H/5 * * * *') // Poll GitHub every 5 min
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
                    // Strip 'origin/' prefix from branch name for consistency
                    env.BRANCH_NAME = (env.GIT_BRANCH ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()).replace('origin/', '')

                    // Map branch to Docker repo
                    if (env.BRANCH_NAME == "dev") {
                        env.REPO = "dev"
                    } else if (env.BRANCH_NAME == "master") {
                        env.REPO = "prod"
                    } else {
                        error("Unsupported branch: ${env.BRANCH_NAME}")
                    }

                    echo "Branch: ${env.BRANCH_NAME}, Docker Repo: ${env.REPO}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Git commit hash as Docker tag
                    env.TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.DOCKER_IMAGE = "${DOCKER_USER}/${REPO}:${TAG}"
                    
                    echo "Building Docker image: ${DOCKER_IMAGE}"

                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker tag ${DOCKER_IMAGE} ${DOCKER_USER}/${REPO}:latest
                    """
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USR', passwordVariable: 'DOCKERHUB_PSW')]) {
                    script {
                        sh """
                            echo ${DOCKERHUB_PSW} | docker login -u ${DOCKERHUB_USR} --password-stdin
                            docker push ${DOCKER_IMAGE}
                            docker push ${DOCKER_USER}/${REPO}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy Application') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps {
                script {
                    // Deploy via SSH only on dev or master
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@35.172.212.253 'bash -s' < ./deploy.sh
                    """
                }
            }
        }

    } // end of stages

    post {
        success {
            echo "Pipeline completed successfully for ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for ${env.BRANCH_NAME}"
        }
    }
}

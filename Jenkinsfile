pipeline {
    agent any

    environment {
        DOCKER_USER = "karthikarajendran19"
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
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
                    // Use env.BRANCH_NAME so it is global
                    env.BRANCH_NAME = env.GIT_BRANCH ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    
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
                    env.TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    
                    sh """
                        docker build -t ${DOCKER_USER}/${REPO}:${TAG} .
                        docker tag ${DOCKER_USER}/${REPO}:${TAG} ${DOCKER_USER}/${REPO}:latest
                    """
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USR', passwordVariable: 'DOCKERHUB_PSW')]) {
                    sh """
                        echo ${DOCKERHUB_PSW} | docker login -u ${DOCKERHUB_USR} --password-stdin
                        docker push ${DOCKER_USER}/${REPO}:${TAG}
                        docker push ${DOCKER_USER}/${REPO}:latest
                    """
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@35.172.212.253 'bash -s' < ./deploy.sh
                    """
                }
            }
        }

    } // stages

    post {
        success {
            echo "Pipeline completed successfully for ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for ${env.BRANCH_NAME}"
        }
    }
}

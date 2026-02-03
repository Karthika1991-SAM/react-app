README Content for DevOps Capstone
Project Overview

This project demonstrates a complete DevOps workflow including:

Application deployment on AWS EC2

Dockerization and container orchestration using docker-compose

CI/CD pipeline using Jenkins

Version control with Git/GitHub

Monitoring and alerting for application health

The application runs on port 80 and can be accessed via the EC2 public IP.

Features

Dockerized application with Dockerfile and docker-compose

Automated build and deployment scripts (build.sh and deploy.sh)

CI/CD pipeline with branch-based deployment (dev → dev repo, master → prod repo)

Deployment on AWS t2.micro instance with secure SSH and HTTP access

Health monitoring and notifications if the application goes down

Architecture

GitHub Repo → source code and version control

Docker & Docker Hub → containerized application and image storage

Jenkins → automated build, push, and deploy pipeline

AWS EC2 → server hosting the application

Monitoring system → checks application health and triggers alerts

Setup & Deployment

Clone the repository from GitHub

Build the Docker image using the build script

Deploy the application with the deploy script

Application runs on port 80 and can be accessed via the server IP

CI/CD Pipeline (Jenkins)

Dev branch: builds and pushes Docker image to dev Docker Hub repo

Master branch: merges dev branch and pushes image to prod Docker Hub repo

Automatic deployment to the server after build completion

Webhooks used to trigger Jenkins jobs on GitHub push

AWS Configuration

EC2 instance: t2.micro

Security Group rules:

HTTP (port 80) → open to all

SSH (port 22) → restricted to your IP only

Docker and docker-compose installed on EC2 for deployment

Monitoring

Application health checks configured using a simple monitoring script

Sends notifications only if the application is down

Optional: can be extended using open-source tools like Prometheus/Grafana or UptimeRobot

Docker Hub Repositories

Dev repo: public

Prod repo: private

Docker images tagged and pushed according to branch strategy

Author ,
Karthika.R
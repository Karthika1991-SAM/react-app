#!/bin/bash

APP_NAME="devops-build"
TAG=$(git rev-parse --short HEAD)
DOCKER_USER="karthikarajendran19"

echo "Building Docker image..."
docker build -t $DOCKER_USER/dev:$TAG .

echo "Tagging image..."
docker tag $DOCKER_USER/dev:$TAG $DOCKER_USER/dev:latest

echo "Pushing images to Docker Hub..."
docker push $DOCKER_USER/dev:$TAG
docker push $DOCKER_USER/dev:latest

echo "Build and push completed successfully."

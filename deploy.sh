#!/bin/bash

DOCKER_USER="karthikarajendran19"
IMAGE="dev"
CONTAINER_NAME="devops-app"

echo "Pulling latest image..."
docker pull $DOCKER_USER/$IMAGE:latest

echo "Stopping existing container (if any)..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Starting new container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  --restart always \
  $DOCKER_USER/$IMAGE:latest

echo "Deployment completed successfully."

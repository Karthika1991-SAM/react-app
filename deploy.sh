#!/bin/bash

set -e

DOCKER_USER="karthikarajendran19"
CONTAINER_NAME="devops_app"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" == "dev" ]; then
  REPO="dev"
elif [ "$BRANCH" == "master" ]; then
  REPO="prod"
else
  echo "Unsupported branch: $BRANCH"
  exit 1
fi

echo "Deploying from Docker Hub repo: $REPO"

echo "Pulling latest image..."
docker pull $DOCKER_USER/$REPO:latest

echo "Stopping existing container (if any)..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "Starting new container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  --restart always \
  $DOCKER_USER/$REPO:latest

echo "Deployment completed successfully"

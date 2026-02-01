#!/bin/bash

APP_NAME="devops-build"
TAG=$(git rev-parse --short HEAD)
DOCKER_USER="karthikarajendran19"

echo "Building Docker image..."
docker build -t $DOCKER_USER/dev:$TAG .

echo "docker build completed. "

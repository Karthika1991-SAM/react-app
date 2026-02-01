#!/bin/bash

set -e

DOCKER_USER="karthikarajendran19"
TAG=$(git rev-parse --short HEAD)
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" == "dev" ]; then
  REPO="dev"
elif [ "$BRANCH" == "master" ]; then
  REPO="prod"
else
  echo "Unsupported branch: $BRANCH"
  exit 1
fi

echo "Branch detected: $BRANCH"
echo "Building image for $REPO repository..."

docker build -t $DOCKER_USER/$REPO:$TAG .
docker tag $DOCKER_USER/$REPO:$TAG $DOCKER_USER/$REPO:latest

echo "Pushing image to Docker Hub..."
docker push $DOCKER_USER/$REPO:$TAG
docker push $DOCKER_USER/$REPO:latest

echo "Build & push completed for $REPO"

#!/bin/bash
set -e

IMAGE_NAME=karthikarajendran19/dev-app
TAG=$(git rev-parse --short HEAD)

docker build -t $IMAGE_NAME:$TAG .
docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:latest

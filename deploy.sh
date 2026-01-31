#!/bin/bash
set -e

IMAGE_NAME=karthikarajendran19/dev-app:latest

docker pull $IMAGE_NAME
docker stop app || true
docker rm app || true
docker run -d -p 80:80 --name app $IMAGE_NAME

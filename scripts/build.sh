#!/bin/bash
echo "Building the docker image"

source .env
cp $DOCKERFILE Dockerfile
docker build -t $IMAGE:$VERSION .

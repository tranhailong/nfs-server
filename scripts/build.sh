#!/bin/bash
echo "Building the docker image"

source environment
docker build -t $IMAGE:$VERSION .


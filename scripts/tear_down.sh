#!/bin/bash
echo "Cleaning up the container and images"

source environment
docker stop $CONTAINER_NAME
docker container rm $CONTAINER_NAME
echo "y" | docker container prune
echo "y" | docker image prune


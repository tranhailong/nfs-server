#!/bin/bash
echo "Cleaning up the container and images"

source .env
docker stop $CONTAINER_NAME
docker container rm $CONTAINER_NAME
echo "y" | docker container prune
#echo "y" | docker image prune  # build image keep getting deleted

#!/bin/bash
echo "Entering the container to examine"

source environment
docker exec -it $CONTAINER_NAME ash


#!/bin/bash
echo "Entering the container to examine"

source .env
docker exec -it $CONTAINER_NAME ash

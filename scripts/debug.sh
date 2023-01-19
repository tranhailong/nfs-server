#!/bin/bash
echo "Entering the container to examine"

source .env
docker exec -it $_CONTAINER_NAME ash

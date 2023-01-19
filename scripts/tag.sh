#!/bin/bash
echo "Tagging and pushing the docker image"

source .env
docker tag $IMAGE:$VERSION tranhailong/$IMAGE:$VERSION
docker tag $IMAGE:$VERSION tranhailong/$IMAGE:latest 
docker push tranhailong/$IMAGE -a

#!/bin/bash
echo "Tagging and pushing the docker image"

source .env
docker tag $_IMAGE:$TAG_NAME$_TAG_SUFFIX $_REGISTRY/$_IMAGE:$TAG_NAME$_TAG_SUFFIX
docker tag $_IMAGE:$TAG_NAME$_TAG_SUFFIX $_REGISTRY/$_IMAGE:latest 
docker push $_REGISTRY/$_IMAGE -a

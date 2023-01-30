#!/bin/bash
echo "Building the docker image"

source .env
docker build -t $_IMAGE:$TAG_NAME$_TAG_SUFFIX -f $_DOCKERFILE .

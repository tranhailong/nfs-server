#!/bin/bash
echo "Spinninng up the container with the built image"

source .env
docker run -d --name $_CONTAINER_NAME --privileged -p 2049:2049 $_IMAGE:$TAG_NAME$_TAG_SUFFIX;
#docker run -d --name $_CONTAINER_NAME $_IMAGE:$TAG_NAME$_TAG_SUFFIX;

# Note that privileged mode seems to be required (i.e. pass in the sudo, or run everything as root).
# This is to allow the rpc.nfsd to access /proc/fs/nfsd

# Use these options to mount and overwrite the config as well as shared volume
#-v $(pwd)/volumes/share:/share
#-v $(pwd)/config/etc/exports:/etc/exports
#-v $(pwd)/scripts/startup-gcs.sh:/usr/local/bin/startup-gcs.sh

# Not sure if this option is required
#--net=host

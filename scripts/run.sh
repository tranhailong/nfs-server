#!/bin/bash
echo "Spinninng up the container with the built image"

source environment
docker run -d --name $CONTAINER_NAME --privileged -p 2049:2049 -v $(pwd)/volumes/share:/share -v $(pwd)/config/etc/exports:/etc/exports $IMAGE:$VERSION

#--net=host

# Note that privileged mode seems to be required (i.e. pass in the sudo, or run everything as root).
# This is to allow the rpc.nfsd to access /proc/fs/nfsd


#!/bin/ash
# This will be run inside the container to start the NFS daemon

rpc.nfsd --debug 8 --no-nfs-version 3
rpc.mountd --debug all --no-nfs-version 3

if [ ! -f /etc/exports ]; then
  cp /nfs/config/etc/exports /etc/exports
fi
exportfs -rav


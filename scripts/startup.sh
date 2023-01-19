#!/bin/ash
# This will be run inside the container to start the NFS daemon

# If gcsfuse is installed, mount at runtime
if [ -f /usr/local/bin/gcsfuse ]; then
  ash /nfs/scripts/startup-gcs.sh
fi

# Start the NFS daemon
rpc.nfsd --debug 8 --no-nfs-version 3
rpc.mountd --debug all --no-nfs-version 3

# This is to ensure that if a volume is not attached to the container at this default path, 1 is created for the default mountpoint /share. would have been better to read /etc/exports and create dynamically though. also this volume will be ephermeral, which is not ideal
mkdir -pv /share

# If a config file is not mounted to overwrite defaults
if [ ! -f /etc/exports ]; then
  cp /nfs/config/etc/exports /etc/exports
fi

exportfs -rav

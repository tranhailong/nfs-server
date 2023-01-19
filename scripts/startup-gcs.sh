#!/bin/bash
# This will be run inside the container to mount the GCS bucket dynamically

if [ -f /usr/local/bin/startup-gcs.sh ] && \
   [ ! "/usr/local/bin/startup-gcs.sh" = $(readlink -f "$0") ]; then
  ash /usr/local/bin/startup-gcs.sh
  exit
fi

# Edit here to change the mount point, and if you want to static mount a particular bucket, or add other runtime option flags
mkdir -pv /share
gcsfuse -o allow_other /share

# Note dynamic mount is used here, all buckets in this project will be available as sub-dir inside /share. however running ls -l /share will not show anything, you need to explicitly choose the sub-dir e.g. ls -l /share/<bucket>

# Other options available
#--implicit-dirs imply the directory structure if object `/foo/bar` is created directly on gcs using other mechanism without the corresponding `/foo/` directory being created. has performance implications
#--key-file=/path/to/key.json
#GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json  # to supply the gcp credentials
# refer https://cloud.google.com/docs/authentication/application-default-credentials#howtheywork

FROM golang:1.18.4-alpine as builder

RUN apk add git && \
    git clone https://github.com/GoogleCloudPlatform/gcsfuse.git && cd gcsfuse && \
    go install ./tools/build_gcsfuse && \
    build_gcsfuse . /tmp $(git log -1 --format=format:"%H")

FROM alpine:3.17

RUN apk add --no-cache --update --verbose nfs-utils fuse && \
    rm -rf /var/cache/apk /tmp /sbin/halt /sbin/poweroff /sbin/reboot /etc/exports && \
    echo "nfsd /proc/fs/nfsd nfsd defaults 0 0" >> /etc/fstab

COPY --from=builder /tmp/bin/gcsfuse /usr/local/bin/gcsfuse
COPY --from=builder /tmp/sbin/mount.gcsfuse /usr/sbin/mount.gcsfuse
COPY . /nfs

ENTRYPOINT /nfs/scripts/startup.sh && sleep infinity

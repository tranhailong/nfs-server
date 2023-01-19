FROM alpine:3.17
RUN apk add --no-cache --update --verbose nfs-utils && \
    rm -rf /var/cache/apk /tmp /sbin/halt /sbin/poweroff /sbin/reboot /etc/exports && \
    echo "nfsd /proc/fs/nfsd nfsd defaults 0 0" >> /etc/fstab
COPY . /nfs

ENTRYPOINT /nfs/scripts/startup.sh && sleep infinity


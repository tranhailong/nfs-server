## Intro
This is a simplified version of itsthenetwork/nfs-server-alpine, specifically to address my purpose: hosting persistent storage for GKE using GCS Fuse (which is cheaper and more flexible than GCE Persistent Drive or Filestore)

This project is hosted at https://github.com/tranhailong/nfs-server <br>
Image is hosted at [tranhailong/nfs-server](docker.io/tranhailong/nfs-server)

Have also noted various comments about latency, performance and consistency guarantee, and decided that this might be more appropriate for a few use cases:
1. loading relatively static config files that i want to share across pods
2. storing objects (images, file uploads)
3. dev environment where load is low, performance is not mission critical, and costs could be optimised
4. applicable to 3rd party apps that were meant to and written to be cloud-agnostic (i.e. using disk i/o operations instead of directly calling gcs / gcloud api)

Might be less useful for storing db with high frequency i/o, or other operations involving a large number of small files with random access. All subject to testing, but I guess I've mentally prepared myself.

## Progress
POC works, able to run deployment in GKE and mount remotely from home computer and `ls` command shows corresponding items. For the time being this serves my purpose and I'll stop making further changes

## Usage
To build, run, and teardown locally using docker:
1. Update the environment variables in `./.env` to reflect whether you're running nfs-server only, gcsfuse only, or combination
2. Run the respective scripts in `./scripts/` from repo root

For NFS, it's possible to reconfigure and add more shared paths at runtime without rebuilding the image. Edit the `config/etc/exports` and add corresponding volume mounts to `scripts/run.sh`

For gcsfuse, configuration is done by editing `scripts/startup-gcs.sh` and mount it at runtime in `scripts/run.sh`

It's also possible to use in Docker Compose and K8S, see the corresponding samples `docker-compose.yaml` and `k8s-deployment.yaml`, edit accordingly.

## Decisions and Notes
- GKE internal cluster only able to load images from GCP Artifact Registry, thus using GCP Cloud Build to automatically load the images in there.
- GCP authentication for the container - there are 2 routes (service account and creating manual key.json and mount it inside the container). I prefer service account, as it's cleaner and avoid hacking it as well as having secrets lying around. Managed to make it work by creating GCP IAM Service Account and link to the GKE K8S Service Account using Workload Identity

## Tests
I tried to write some automated tests for NFS, but it got stuck at running `sudo mount` on the host machine. Not sure if this is corresponding to the ipv6 bug menntioned in the referenced image. I'll have a look at it when i can.

Another attempt at running tests from within another container on the same host machine got me this cryptic error.
```
/ # mount -v -t nfs -o nolock <host>:/share /test
mount.nfs: Operation not permitted
mount: mounting <host>:/share on /test failed: Not supported
```

Contemplating if i should run the 2nd container as a separate network to trick the server into thinking this is connecting from lan rather than going from the same machine.

For now i'm stuck to running manual tests on a separate host (without the `-o nolock` flag), which is able to mount and perform read/write

For GCS Fuse, looks a little more promising. potentially just need to `df -h` to verify mount point, touch a file and check the bucket using gcs api, which is probably simpler than having to run both server and client on the same machine.

## Versioning
Releases are tagged based on the `${UNDERLYING_PACKAGE_VERSION}-${VERSION}`. <br>
`${UNDERLYING_PACKAGE_VERSION}` refers to NFS (4.2) / GCS Fuse (0.41.11) as of 2023/01/20. <br>
So current releases would be `nfs-server:4.2-1`, `nfs-server:4.2-1-gcsfuse`, `gcsfuse:0.41.11-1`

## References
- [itsthenetwork/nfs-server-alpine](https://github.com/sjiveson/nfs-server-alpine) - a more thoroughly built and flexible NFS server with more error handling and support for more architecture. Our NFS server is a purpose-built reduction from this image.
- [gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse) - instructions on compiling and running gcsfuse
- [GKE Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) - recommended approach to authentications on GKE
- [POC NFS on K8S](https://westzq1.github.io/k8s/2019/06/28/nfs-server-on-K8S.html) - another guide i thought was quite fit to follow for my use case

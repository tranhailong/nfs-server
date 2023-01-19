## Intro
This is a simplified version of itsthenetwork/nfs-server-alpine, specifically to address my purpose: hosting persistent storage for GKE using GCS Fuse (which is cheaper and more flexible than GCE Persistent Drive or Filestore)

This project is hosted at https://github.com/tranhailong/nfs-server
Image is hosted at [tranhailong/nfs-server](docker.io/tranhailong/nfs-server)

Have also noted various comments about latency, performance and consistency guarantee, and decided that this might be more appropriate for a few use cases:
1. loading relatively static config files that i want to share across pods
2. storing objects (images, file uploads)
3. dev environment where load is low, performance is not mission critical, and costs could be optimised
4. applicable to 3rd party apps that were meant to and written to be cloud-agnostic (i.e. using disk i/o operations instead of directly calling gcs / gcloud api)

Might be less useful for storing db with high frequency i/o, or other operations involving a large number of small files with random access. All subject to testing, but I guess I've mentally prepared myself.

## Progress
nfs-server and gcsfuse run fine together (at least able to share out the gcs mounted path). unable to test nfs client connecting to this yet

## Usage
To build, run, and teardown,
1. Update the environment variables in `./.env` to reflect whether you're running nfs-server only, gcsfuse only, or combination
2. Run the respective scripts in `./scripts/` from repo root

For NFS, it's possible to reconfigure and add more shared paths at runtime without rebuilding the image. Edit the `config/etc/exports` and add corresponding volume mounts to `scripts/run.sh`

For gcsfuse, configuration is done by editing `scripts/startup-gcs.sh` and mount it at runtime in `scripts/run.sh`

It's also possible to use in Docker Compose and K8S, see the corresponding samples `docker-compose.yaml` and `k8s-deployment.yaml`, edit accordingly.

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
Releases are tagged based on the underlying package (NFS / GCS Fuse) for now, so you have 4.2 for NFS and 0.41.11 for GCS Fuse related image (as of 2023/01/19). That doesn't mean I have gone through 4 major versions :)

## References
- [itsthenetwork/nfs-server-alpine](https://github.com/sjiveson/nfs-server-alpine) - a more thoroughly built and flexible NFS server with more error handling and support for more architecture. Our NFS server is a purpose-built reduction from this image.
- [gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse) - instructions on compiling and running gcsfuse

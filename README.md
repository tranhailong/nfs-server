### Intro
This is a simplified version of itsthenetwork/nfs-server-alpine, specifically to address my purpose: hosting persistent storage for GKE using GCS Fuse (which is cheaper and more flexible than GCE Persistent Drive or Filestore)

This project is hosted at ???

### Usage
To build, run, and teardown, run the respective scripts in `./scripts`

It's possible to reconfigure and add more shared paths at runtime without rebuilding the image. Edit the `config/etc/exports` and add corresponding volume mounts to `scripts/run.sh`

It's also possible to use in Docker Compose and K8S, see the corresponding samples `docker-compose.yaml` and `k8s-deployment.yaml`, edit accordingly.

### Tests
I tried to write some tests, but it got stuck at running `sudo mount`. Not sure if this is corresponding to the ipv6 bug menntioned in the referenced image. I'll have a look at it when i can

### References
[itsthenetwork/nfs-server-alpine](https://github.com/sjiveson/nfs-server-alpine) - a more thoroughly built and flexible NFS server with more error handling and support for more architecture. Our NFS server is a purpose-built reduction from this image.



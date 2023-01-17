## Steps required in general
POC done on Fedora Workstation, need to adapt steps to Alpine in container (e.g. using apk instead of dnf, with no systemd equivalent)

### 0. Environment Variables
`$NFS_SERVER_IP` - IP address of the host running nfs-server, sharing out its drive
`$NFS_SHARE` - absolute path to the shared folder on the server
`$NFS_CLIENT_IP` - IP address of the host running nfs client, mounting the shared drive
`$NFS_MOUNT` - absolute path to mount the shared folder on the client

To evaluate these variables where applicable (e.g. if added to config files)

### 1. Install nfs-utils
on both the server and client
```
sudo dnf update -y && sudo dnf install nfs-utils -y
```

### 2. On server, start the service
nfs-server for the nfs server, rpcbind for discovery using `showmount -e` later on (not strictly required)
```
sudo systemctl start nfs-server && sudo systemctl enable nfs-server
sudo systemctl start rpcbind
```
Also note that rpcbind might already be started by Fedora or another package before this.

To check status
```
sudo systemctl status nfs-server
sudo systemctl status rpcbind
rpcinfo -p | grep nfs  # there should be 3 lines with pid, version, protocol, port, service. 1x for nfs v4, 2x for nfs and nfs_acl v3
```

There should also be some configuration files at `/etc/nfs.conf` and `/etc/nfsmount.conf`, but no tweaking was required to get poc running

### 3. On server, need to designate the path to share
```
mkdir -pv $NFS_SHARE
sudo vi /etc/exports
```

In `/etc/exports` add this line
```
$NFS_SHARE $NFS_CLIENT_IP(rw,async,no_root_squash)
```
`$NFS_SHARE` should be the absolute path
`$NFS_CLIENT_IP` is for the client, could be an absolute IP, a CIDR subnet, or `*` wildcard
`rw` for read write access, `ro` for read only
`async` or `sync`
`no_root_squash` allows client's root to write files with owner root on the server
another one is `no_all_squash`, so each user on client machine would write files with their own username onto the server
`fsid=0` to allow client to connect to `$NFS_SERVER_IP:/` instead of `$NFS_SERVER_IP:$NFS_SHARE`. in a way it's more convenient because you don't need to know the `$NFS_SHARE` path
`no_subtree_check`, `no_auth_nlm`, `insecure` are a couple other options, consult NFS documentations

Then finally, export the shared path
```
exportfs -rav
```

To check
```
showmount -e
```

### 4. On server, also need to open firewall
```
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --reload
```
During POC, it appears only rpc-bind needs to be added, the other 2 wasn't required and the nfs client was already able to mount
So not strictly necessary if you don't want to use `showmount -e $NFS_SERVER` on the client side

### 5. On client, set up
```
showmount -e $NFS_SERVER_IP  # optional step since we already know the $NFS_SHARE. can use FQDN or local network hostname if you can ping it
mkdir -pv $NFS_MOUNT
sudo mount -t nfs $NFS_SERVER_IP:$NFS_SHARE $NFS_MOUNT
```

To check
```
sudo mount | grep -i nfs
df -h  | grep $NFS_MOUNT  # alternative option
```

To persist mount across reboot, add this line to `/etc/fstab/`
```
$NFS_SERVER_IP:$NFS_SHARE $NFS_MOUNT nfs defaults 0 0
```

To unmount
```
sudo umount $NFS_MOUNT
```

### 6. Testing
On server
```
ls -lt $NFS_SHARE
touch $NFS_SHARE/test_server
```

On client check that the new file sync over
```
ls -lt $NFS_MOUNT
```

And vice versa

## Assumptions
Code examples are based on Fedora Workstation using dnf package manager and systemd



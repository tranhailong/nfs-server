#!/bin/bash
echo "Tearing down K8S deployment using helm"

helm delete -n nfs nfs-server

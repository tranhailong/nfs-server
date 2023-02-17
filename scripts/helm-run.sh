#!/bin/bash
echo "Deploying to K8S using helm"

helm repo add tranhailong https://tranhailong.github.io/charts
helm install -n nfs nfs-server tranhailong/nfs-server -f helm-values.yaml
helm list -n nfs

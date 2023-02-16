#!/bin/bash
echo "Deploying to K8S using helm"

helm install -n nfs nfs-server helm -f helm-values.yaml
helm list -n nfs

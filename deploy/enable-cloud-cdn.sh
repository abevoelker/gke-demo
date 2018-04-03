#!/bin/bash
# usage: enable-cloud-cdn.sh INGRESS-NAME SERVICE-NAME
set -eu
BACKENDS=$(kubectl get ing "$1" -o json | jq -rc '.metadata.annotations."ingress.kubernetes.io/backends" | fromjson | keys | .[]')
for backend in $BACKENDS; do
  SERVICE_NAME=$(gcloud compute backend-services describe --global --format=json "${backend}" | jq -r '.description | fromjson | ."kubernetes.io/service-name"')
  if [[ "$SERVICE_NAME" == *"$2" ]]
  then
      echo "enabling Cloud CDN for backend $backend"
      gcloud compute backend-services update --global "${backend}" --enable-cdn
  fi
done

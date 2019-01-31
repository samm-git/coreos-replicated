#!/bin/bash

## Script to get airgapped image of the replited for the specific release
## variables to set:
## REPLICATED_PWD - password for the airgapped releases
## LICENSE_ID - license_id
## RELEASE_NUMBER - terraform release number, e.g. 314

set -e
set -o pipefail

me=replicated

echo "[${me}]: Getting url for the airgapped download"

BASE64_REPLICATED_PWD=$(echo -n "${REPLICATED_PWD}" | base64)

# get link for specific release
LINK=$(curl \
  "https://api.replicated.com/market/v1/airgap/images/url?license_id=${LICENSE_ID}&sequence=${RELEASE_NUMBER}" \
  --header "Authorization: Basic ${BASE64_REPLICATED_PWD}" \
  | jq -r .url
  )

echo "[${me}]: Downloading release from ${LINK}"
mkdir -p /var/lib/install-ptfe
curl -L -o /var/lib/install-ptfe/archive.tgz "${LINK}"
echo "[${me}]: done"

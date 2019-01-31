#!/bin/bash

## This script downloads latest stable airgap replicated package and adds it to the docker
## All images are additionally tagged as :current

set -e
set -o pipefail

me=replicated

echo "[${me}]: Creating 'replicated' user"
useradd -u 1000 -g docker replicated

echo "[${me}]: Enabling docker"
systemctl enable docker

echo "[${me}]: Temporary stopping systemctl services"
systemctl stop replicated replicated-ui replicated-operator

echo "[${me}]: Generating token"
TOKEN="$(head -c 128 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
echo "DAEMON_TOKEN=${TOKEN}" > /etc/default/replicated-token
echo "[${me}]: Installing replicated"
mkdir -p /var/lib/install
cd /var/lib/install
wget --no-verbose https://s3.amazonaws.com/replicated-airgap-work/replicated.tar.gz
tar -xvzf replicated.tar.gz
docker load -i cmd.tar
docker load -i premkit.tar
docker load -i replicated-operator.tar
docker load -i replicated-ui.tar
docker load -i replicated.tar
docker load -i retraced-nsqd.tar
docker load -i retraced-postgres.tar
docker load -i retraced.tar
docker load -i statsd-graphite.tar
# tagging images with :current
IMGS="
  quay.io/replicated/replicated
  quay.io/replicated/replicated-ui
  quay.io/replicated/replicated-operator
"
for img in ${IMGS}; do
 REPL_V="$(docker images "${img}" --format '{{.Tag}}')"
 docker tag ${img}:${REPL_V} ${img}:current
done

echo "[${me}]: Cleanup"
rm -rf /var/lib/install

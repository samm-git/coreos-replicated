#!/bin/bash

set -e
set -o pipefail

me=init

echo "[${me}]: placing files"
rsync -rv /tmp/files/ /

echo "[${me}]: setting binary permissions"
chmod 755 /opt/bin/*

echo "[${me}]: enabling systemd units"
pushd /tmp/files/etc/systemd/system/
for unit in *; do
  [[ -f ${unit} ]] && systemctl enable ${unit}
done
popd

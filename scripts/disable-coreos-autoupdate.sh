#!/bin/bash

# Disables CoreOS auto update mechanism as we prefer an immutable infrastructure
# approach. See https://coreos.com/os/docs/latest/update-strategies.html for
# "Disable Automatic Updates Daemon".

set -e
set -o pipefail

me=disable-coreos-autoupdate

echo "[${me}]: Mask locksmithd.service"

systemctl stop locksmithd.service
systemctl mask locksmithd.service

echo "[${me}]: Mask update-engine.service"

systemctl stop update-engine.service
systemctl mask update-engine.service

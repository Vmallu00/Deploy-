#!/bin/bash
set -e

echo "Starting rootless Docker daemon..."

if [ ! -S /run/user/1000/docker.sock ]; then
    exec dockerd-rootless \
        --host unix:///run/user/1000/docker.sock \
        --host tcp://0.0.0.0:2375 \
        --data-root /home/railway/.local/share/docker
else
    echo "Docker socket already exists."
    exec /bin/bash
fi

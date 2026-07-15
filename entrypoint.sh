#!/bin/bash
set -e

export PATH=/home/railway/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock

if [ ! -S /run/user/1000/docker.sock ]; then
    echo "Starting rootless Docker daemon..."
    exec /home/railway/bin/dockerd-rootless \
        --data-root /home/railway/.local/share/docker
else
    echo "Docker is already running."
    exec /bin/bash
fi

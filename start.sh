#!/bin/bash
set -e

echo "Starting Docker daemon with iptables=false, bridge=none, storage-driver=vfs..."
exec dockerd \
    --iptables=false \
    --bridge=none \
    --storage-driver=vfs \
    --log-level=info

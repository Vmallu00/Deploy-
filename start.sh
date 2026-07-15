#!/bin/bash
set -e

echo "Starting Docker daemon (rootful) with no iptables/bridge..."
mkdir -p /var/run

# Run dockerd in foreground – this keeps the container alive
exec dockerd \
    --iptables=false \
    --bridge=none \
    --storage-driver=vfs \
    --log-level=info

#!/bin/bash
set -e

echo "Starting Docker daemon..."
dockerd --iptables=false --bridge=none &

# Wait for dockerd to be ready
sleep 5
echo "Docker daemon started. Container is alive."

# Keep the container running forever
exec sleep infinity

#!/bin/bash
set -e

echo "Starting Docker daemon with VFS storage driver (config from daemon.json)..."
exec dockerd

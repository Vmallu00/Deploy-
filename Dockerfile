FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Podman + Docker alias
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    vim-tiny \
    htop \
    podman \
    podman-docker \
    && rm -rf /var/lib/apt/lists/*

# Optionally set storage driver to vfs (more compatible)
ENV CONTAINER_STORAGE_DRIVER=vfs

EXPOSE 8080

# Keep the container alive – run as root (default)
CMD ["sleep", "infinity"]

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    vim-tiny \
    htop \
    podman \
    podman-docker \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash railway && \
    echo "railway ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER railway
WORKDIR /home/railway

EXPOSE 8080

CMD ["sleep", "infinity"]

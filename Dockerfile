FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    iptables \
    uidmap \
    dbus-user-session \
    git \
    vim-tiny \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user (required for rootless Docker)
RUN useradd -m -s /bin/bash railway && \
    echo "railway ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER railway
WORKDIR /home/railway

# Install rootless Docker (installs into ~/bin, no system packages needed)
RUN curl -fsSL https://get.docker.com/rootless -o install-rootless.sh && \
    sh install-rootless.sh

# Set Docker environment variables
ENV DOCKER_HOST=unix:///run/user/1000/docker.sock
ENV PATH=/home/railway/bin:$PATH

# Copy and set up entrypoint
COPY --chown=railway:railway entrypoint.sh /home/railway/entrypoint.sh
RUN chmod +x /home/railway/entrypoint.sh

EXPOSE 8080

CMD ["/home/railway/entrypoint.sh"]

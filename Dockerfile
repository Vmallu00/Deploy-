FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites for adding a new repository
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    iptables \
    uidmap \
    dbus-user-session \
    git \
    vim-tiny \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key and repository (manual, bulletproof way)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, CLI, containerd, and rootless extras
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-rootless-extras \
    && rm -rf /var/lib/apt/lists/*

# Create non‑root user (required for rootless mode)
RUN useradd -m -s /bin/bash railway && \
    echo "railway ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER railway
WORKDIR /home/railway

# Setup subuid/subgid for rootless Docker
RUN echo "railway:100000:65536" | sudo tee -a /etc/subuid && \
    echo "railway:100000:65536" | sudo tee -a /etc/subgid

# Environment variables for Docker
ENV DOCKER_HOST=unix:///run/user/1000/docker.sock
ENV PATH=/usr/bin:$PATH

# Copy and set up entrypoint
COPY --chown=railway:railway entrypoint.sh /home/railway/entrypoint.sh
RUN chmod +x /home/railway/entrypoint.sh

EXPOSE 8080

CMD ["/home/railway/entrypoint.sh"]

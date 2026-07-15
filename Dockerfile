FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for rootless Docker
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

# Install Docker CLI and rootless extras
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
RUN apt-get install -y docker-rootless-extras

# Create non-root user (rootless Docker needs a non-root user)
RUN useradd -m -s /bin/bash railway && \
    echo "railway ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER railway
WORKDIR /home/railway

# Setup subuid/subgid for rootless mode
RUN echo "railway:100000:65536" | sudo tee -a /etc/subuid && \
    echo "railway:100000:65536" | sudo tee -a /etc/subgid

# Environment variables
ENV DOCKER_HOST=unix:///run/user/1000/docker.sock
ENV PATH=/usr/bin:$PATH

# Copy entrypoint
COPY --chown=railway:railway entrypoint.sh /home/railway/entrypoint.sh
RUN chmod +x /home/railway/entrypoint.sh

EXPOSE 8080

CMD ["/home/railway/entrypoint.sh"]

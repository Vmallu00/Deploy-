FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Podman and its dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    vim-tiny \
    htop \
    podman \
    podman-docker  # This creates /usr/bin/docker symlink to podman \
    && rm -rf /var/lib/apt/lists/*

# Create a non‑root user (best practice)
RUN useradd -m -s /bin/bash railway && \
    echo "railway ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER railway
WORKDIR /home/railway

# (Optional) Set environment variable to make podman use rootless mode
ENV PATH=/usr/bin:$PATH

# Copy a simple entrypoint that just runs a shell
COPY --chown=railway:railway entrypoint.sh /home/railway/entrypoint.sh
RUN chmod +x /home/railway/entrypoint.sh

EXPOSE 8080

CMD ["/home/railway/entrypoint.sh"]

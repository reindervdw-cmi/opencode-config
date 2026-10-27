FROM ghcr.io/anomalyco/opencode:2.1.4

USER root

RUN apk add --no-cache \
    bash \
    build-base \
    ca-certificates \
    cargo \
    curl \
    git \
    libffi-dev \
    linux-headers \
    nodejs \
    npm \
    openssh-client \
    openssl-dev \
    python3 \
    python3-dev \
    rust \
    uv

# Azure CLI is not packaged in the base image's Alpine repositories.
RUN uv venv --python /usr/bin/python3 /opt/azure-cli \
    && uv pip install --no-cache --prerelease allow --python /opt/azure-cli/bin/python azure-cli==2.91.0 pip \
    && ln -s /opt/azure-cli/bin/az /usr/local/bin/az

# Install the DevOps extension at build time for the runtime user.
ENV AZURE_EXTENSION_DIR=/opt/azure-cli/extensions
RUN AZURE_CONFIG_DIR=/tmp/azure-cli-build az extension add --name azure-devops --yes \
    && rm -rf /tmp/azure-cli-build

# Keep nvm separate from host-installed Node binaries, which may require glibc.
ENV NVM_DIR=/opt/nvm
RUN git clone --depth 1 --branch v0.40.8 https://github.com/nvm-sh/nvm.git "$NVM_DIR" \
    && chown -R 1000:1000 "$NVM_DIR" \
    && printf '%s\n' '. "$NVM_DIR/nvm.sh" --no-use' > /etc/profile.d/nvm.sh

# OpenCode runs non-interactive Bash commands; those do not read profile files.
ENV BASH_ENV=/etc/profile.d/nvm.sh

USER 1000:1000

# Compose sets HOME at runtime, but the build user has no writable home.
RUN HOME="$(mktemp -d)" bash -c 'export AZURE_CONFIG_DIR="$HOME/.azure" \
    && az --version && az boards --help \
    && git --version && uv --version && cargo --version && rustc --version && node --version && npm --version && nvm --version'

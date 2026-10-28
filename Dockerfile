FROM cuelang/cue:0.17.1 AS cue-source
FROM ghcr.io/anomalyco/opencode:2.1.4

USER root

COPY --from=cue-source /usr/bin/cue /usr/local/bin/cue

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

# Keep container interpreters separate from host-mounted uv installations.
ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python
ENV UV_PYTHON_BIN_DIR=/opt/uv/bin
ENV PATH="/opt/uv/bin:${PATH}"

RUN uv python install 3.12 3.13 3.14 \
    && /opt/uv/bin/python3.12 --version \
    && /opt/uv/bin/python3.13 --version \
    && /opt/uv/bin/python3.14 --version

ENV UV_TOOL_DIR=/opt/uv/tools
ENV UV_TOOL_BIN_DIR=/usr/local/bin

# Common Python tools
RUN uv tool install --python 3.12 prek \
    && prek --version

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
    && cue version && git --version && uv --version && cargo --version && rustc --version && node --version && npm --version && nvm --version'

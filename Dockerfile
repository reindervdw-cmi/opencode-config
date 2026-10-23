FROM ghcr.io/anomalyco/opencode:2.1.4

USER root

RUN apk add --no-cache \
    bash \
    build-base \
    ca-certificates \
    cargo \
    curl \
    git \
    linux-headers \
    nodejs \
    npm \
    openssh-client \
    python3 \
    rust \
    uv

# Keep nvm separate from host-installed Node binaries, which may require glibc.
ENV NVM_DIR=/opt/nvm
RUN git clone --depth 1 --branch v0.40.8 https://github.com/nvm-sh/nvm.git "$NVM_DIR" \
    && chown -R 1000:1000 "$NVM_DIR" \
    && printf '%s\n' '. "$NVM_DIR/nvm.sh" --no-use' > /etc/profile.d/nvm.sh

# OpenCode runs non-interactive Bash commands; those do not read profile files.
ENV BASH_ENV=/etc/profile.d/nvm.sh

USER 1000:1000

RUN bash -c 'git --version && uv --version && cargo --version && rustc --version && node --version && npm --version && nvm --version'

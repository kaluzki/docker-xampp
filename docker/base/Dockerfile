# docker build docker/base -f docker/base/Dockerfile -t xampp/base
# docker run --rm -ti xampp/base bash

ARG from=debian:trixie-slim

# ---- Stage 1: Base System (curl, ca-certificates, mise) ----
FROM ${from} AS base-system

COPY --from=jdxcode/mise:latest /usr/local/bin/mise /usr/local/bin/mise

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked <<EOF
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates
EOF

# ---- Stage 2: Builder (mise tools) ----
FROM base-system AS builder

RUN --mount=type=cache,target=/root/.cache/mise,sharing=locked \
    --mount=type=cache,target=/root/.local/share/mise,sharing=locked <<EOF
    set -eux
    # Prepare output directory with binaries
    mkdir -p /mise

    # Define tools to install (format: package[:binary])
    TOOLS="bat eza fd ripgrep:rg zoxide bun starship"
    
    for item in $TOOLS; do
        tool="${item%%:*}"
        binary="${item##*:}"
        
        echo "Installing $tool (binary: $binary)..."
        mise use -g "${tool}"
        
        # Extract binary from mise installation
        cp "$(mise which "$binary")" /mise/
    done
EOF

# ---- Stage 3: Final Image ----
FROM base-system

LABEL org.opencontainers.image.vendor="Demjan Kaluzki"
LABEL org.opencontainers.image.source="https://github.com/kaluzki/docker-xampp/"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked <<EOF
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        bash-completion \
        iproute2 \
        git
EOF

COPY --from=builder /mise/ /usr/local/bin/
COPY --from=ghcr.io/netresearch/ofelia /usr/bin/ofelia /usr/local/bin/ofelia
COPY etc /etc

RUN <<EOF cat >> /etc/bash.bashrc
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
[[ -d "/etc/xampp.d" ]] && {
  for script in "/etc/xampp.d/"*.sh; do
    . "\$script"
  done
  unset script
}
EOF

### USER
ARG user=app
ARG uid=1000
RUN <<EOF
    set -eux
    groupadd -g ${uid} ${user}
    useradd -u ${uid} -g ${uid} -m -s /bin/bash -k /dev/null ${user}
    mkdir -p /app /opt /resources
    chown ${uid}:${uid} /app /opt /resources
EOF

USER ${user}
WORKDIR /app

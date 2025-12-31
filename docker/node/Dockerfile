# docker build docker/node -f docker/node/Dockerfile -t xampp/node
# docker run --rm -ti xampp/node

FROM xampp/base

ENV NVM_DIR=/opt/nvm

ARG nvm=v0.40.3
ARG node=lts

RUN <<EOF
    set -eux
    curl -s https://raw.githubusercontent.com/creationix/nvm/${nvm}/install.sh | XDG_CONFIG_HOME=/opt bash
    bash -c "source $NVM_DIR/nvm.sh && nvm install --${node}"
EOF

COPY <<EOF /etc/xampp.d/30-nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF

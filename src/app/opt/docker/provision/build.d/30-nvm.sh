#!/usr/bin/env bash

set -e

mkdir -p /opt/nvm
PROFILE=/dev/null curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | NVM_DIR=/opt/nvm bash

export NVM_DIR="/opt/nvm"
\. /opt/nvm/nvm.sh

# node v20.11.1 (npm v10.2.4)
nvm install --lts

chown 1000:1000 /opt/nvm -R

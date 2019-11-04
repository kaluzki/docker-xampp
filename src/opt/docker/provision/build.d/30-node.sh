#!/usr/bin/env bash

curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-install autoconf libtool libpng-dev nasm nodejs
npm install --global npm @quasar/cli @vue/cli

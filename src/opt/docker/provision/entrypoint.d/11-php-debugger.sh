#!/usr/bin/env bash

for CONF_PATH in ${PHP_CONF_PATHS}; do
    rm -f "${CONF_PATH}"/xdebug.ini
    rm -f "${CONF_PATH}"/blackfire.ini
done

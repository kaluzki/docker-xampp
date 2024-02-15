#!/usr/bin/env bash

if [[ ${DOCKER_XAMPP_BIN_ENV:-} == "prod" ]]; then
    for CONF_PATH in ${PHP_CONF_PATHS}; do
        rm -f "${CONF_PATH}"/*xdebug.ini
        rm -f "${CONF_PATH}"/*blackfire.ini
    done
fi

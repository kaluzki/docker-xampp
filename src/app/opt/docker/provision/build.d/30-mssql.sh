#!/usr/bin/env bash

set -e

if [[ $(docker-image-info dist-codename) = "buster" ]]; then

    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

    ACCEPT_EULA=Y apt-install msodbcsql17 unixodbc-dev mssql-tools

    local version=""
    [[ $(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".") = "7.4" ]] && version="-5.10.1"

    pecl install sqlsrv${version} pdo_sqlsrv${version}
    docker-php-ext-enable sqlsrv pdo_sqlsrv

    go-replace --mode=lineinfile --regex -s 'DEFAULT@SECLEVEL=2' -r 'DEFAULT@SECLEVEL=1' /etc/ssl/openssl.cnf
fi

#!/usr/bin/env bash

function main() {
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

    ACCEPT_EULA=Y apt-install msodbcsql17 unixodbc-dev mssql-tools

    local version=""
    [[ $(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".") = "7.0" ]] && version="-5.3.0"
    pecl install sqlsrv${version} pdo_sqlsrv${version}
    docker-php-ext-enable sqlsrv pdo_sqlsrv
}

[[ $(docker-image-info dist-codename) = "jessie" ]] || main

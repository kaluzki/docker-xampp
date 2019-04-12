#!/usr/bin/env bash

[[ $(docker-image-info dist-codename) = "jessie" ]] || {
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

    ACCEPT_EULA=Y apt-install msodbcsql17 unixodbc-dev mssql-tools

    pecl install sqlsrv pdo_sqlsrv
    docker-php-ext-enable sqlsrv pdo_sqlsrv
}

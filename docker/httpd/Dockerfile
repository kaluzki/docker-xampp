# docker build docker/httpd -f docker/httpd/Dockerfile -t xampp/httpd:2.4 -t xampp/httpd

ARG from=httpd:2.4
FROM ${from}

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        bash-completion
EOF

COPY --from=xampp/base /etc/bash.bashrc /etc/bash.bashrc
COPY --from=xampp/base /etc/xampp.d/ /etc/xampp.d/
COPY --from=xampp/base /etc/gitconfig /etc/gitconfig
COPY --from=xampp/base /usr/local/bin/starship /usr/local/bin/starship

ARG uid=1000
RUN <<EOF
    usermod -u ${uid} www-data
    groupmod -g ${uid} www-data
    mkdir /app/public /var/www -p
    chown www-data:www-data $HTTPD_PREFIX $HTTPD_PREFIX/logs /app /var/www -R
EOF

USER www-data
ENV APP_DOCUMENT_ROOT=/app/public
COPY --chown=www-data:www-data <<EOF $HTTPD_PREFIX/conf/xampp.conf
LoadModule negotiation_module modules/mod_negotiation.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule expires_module modules/mod_expires.so
LoadModule deflate_module modules/mod_deflate.so

LoadModule remoteip_module modules/mod_remoteip.so
RemoteIPHeader X-Forwarded-For
RemoteIPInternalProxy 172.16.0.0/12
SetEnvIf X-Forwarded-Proto https HTTPS=on

LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so

CustomLog /proc/self/fd/1 combined
DocumentRoot \${APP_DOCUMENT_ROOT}
<Directory \${APP_DOCUMENT_ROOT}>
    AllowOverride ALL
    Require all granted
</Directory>
<FilesMatch \.php$>
    SetHandler "proxy:unix:/var/run/php/php-fpm.sock|fcgi://localhost"
</FilesMatch>
EOF

ENTRYPOINT ["httpd-foreground", "-c ServerName localhost", "-c Include conf/xampp.conf"]
CMD []

WORKDIR $HTTPD_PREFIX/conf
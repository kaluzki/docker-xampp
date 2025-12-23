# docker build src/httpd -f src/httpd/Dockerfile -t xampp/httpd:2.4 -t xampp/httpd

ARG httpd=2.4
FROM httpd:${httpd}

RUN <<EOF
usermod -u 1000 www-data
groupmod -g 1000 www-data
mkdir /app/public -p
chown www-data:www-data $HTTPD_PREFIX $HTTPD_PREFIX/logs /app -R
EOF

USER www-data
ENV APP_DOCUMENT_ROOT=/app/public
COPY --chown=www-data:www-data <<EOF $HTTPD_PREFIX/conf/xampp.conf
LoadModule remoteip_module modules/mod_remoteip.so
RemoteIPHeader X-Forwarded-For
RemoteIPInternalProxy 172.16.0.0/12

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
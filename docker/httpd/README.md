# XAMPP Apache Image (`xampp/httpd`)

A modular Apache HTTPD image optimized for serving PHP applications via PHP-FPM in the modern XAMPP Docker stack.

## Overview
Based on the official `httpd:2.4` image, this image is pre-configured to act as a frontend for PHP-FPM, utilizing Unix sockets for high-performance inter-container communication.

## Key Features

*   **PHP-FPM Integration**: Automatically proxies `.php` files to the Unix socket at `/var/run/php/php-fpm.sock`.
*   **Dynamic Document Root**: Use the `APP_DOCUMENT_ROOT` environment variable to change the served directory without rebuilding the image.
*   **Modern HTTPD Modules**: Includes `mod_rewrite`, `mod_deflate`, `mod_expires`, and `mod_proxy_fcgi` enabled by default.
*   **Reverse Proxy Compatibility**:
    *   **HTTPS Detection**: Correcty handles `X-Forwarded-Proto` to set `HTTPS=on` for PHP applications.
    *   **Remote IP**: Configured to trust internal Docker networks for `X-Forwarded-For` headers.
*   **Security**: Runs as a non-root user (`www-data`, UID 1000) by default.
*   **Developer Tooling**: Includes the Starship prompt and bash completion for a consistent terminal experience.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_DOCUMENT_ROOT` | `/app/public` | The absolute path to the directory containing your `index.php`. |

## Usage (Docker Compose)

Must be used with a PHP-FPM service (like `xampp/php`) that shares the socket volume.

```yaml
services:
  httpd:
    image: xampp/httpd:2.4
    volumes:
      - .:/app
      - php-socket:/var/run/php
    labels:
      - traefik.enable=true
      # ... Traefik labels ...

volumes:
  php-socket:
```

## Build Information
Built on `httpd:2.4` (Debian-based). Optimized for use with Traefik or other reverse proxies.

# XAMPP PHP-FPM Image (`xampp/php`)

A modular, high-performance PHP-FPM image designed as the core application worker for the modern XAMPP Docker stack.

## Overview
This image is based on the official `php:fpm` images and follows a decoupled architecture. It is optimized for security, performance, and developer experience.

## Key Features

*   **Intelligent Runtime Switching**: The `php` and `php-fpm` binaries are wrapped in smart scripts.
    *   **Production (Default)**: Uses `php.ini-production` and optimized settings.
    *   **Development**: Automatically switches to `php.ini-development` and enables **Xdebug** if `APP_ENV` is set to anything other than `prod` or `production`.
*   **Modular Communication**: Configured to listen on a Unix socket at `/var/run/php/php-fpm.sock` for high-performance communication with the web server (e.g., `xampp/httpd`).
*   **Comprehensive Extensions**: Includes a wide range of pre-installed extensions (GD, Imagick, Redis, PDO, etc.) managed via the `install-php-extensions` helper.
*   **Developer Tooling**:
    *   **Composer**: Pre-installed and ready to use.
    *   **RoadRunner**: High-performance PHP application server included.
    *   **Starship Prompt**: A fast and customizable shell prompt for an improved terminal experience.
*   **Security**: Runs as a non-root user (`app`, UID 1000) by default.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_ENV` | `prod` | Set to `dev` or `local` to enable Xdebug and development settings. |
| `TZ` | `Europe/Berlin` | System timezone configuration. |
| `PHP_IDE_CONFIG` | `serverName=app.localhost` | Xdebug server configuration for IDEs. |

## Usage (Docker Compose)

Typically used in conjunction with `xampp/httpd`. Note the shared volume for the Unix socket.

```yaml
services:
  php:
    image: xampp/php:8.4
    environment:
      - APP_ENV=dev
    volumes:
      - .:/app
      - php-socket:/var/run/php

volumes:
  php-socket:
```

## Build Information
Built using multi-stage builds and a clean Debian-based foundation. Supports PHP versions 7.4, 8.1, 8.2, 8.3, 8.4, and 8.5.

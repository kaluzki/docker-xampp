# XAMPP Docker Environment

This project provides a modular Docker-based development environment, inspired by the classic XAMPP stack but built with modern containerization principles.

## Overview

The goal is to offer a flexible and robust environment for PHP development, moving away from monolithic containers (like `webdevops/*`) towards a service-oriented architecture where each container handles a specific responsibility.

### Key Features

*   **Modular Architecture**: Separate containers for PHP, Apache (HTTPD), Node.js, and other services.
*   **Non-Root Execution**: Containers are designed to run as a non-root user by default for better security.
*   **Modern Tooling**: Includes support for Composer, Xdebug, and other essential development tools.
*   **Customizable**: Easily extensible via Dockerfiles and configuration scripts.

## Project Evolution

### Origins
Initially motivated by `webdevops/*` images, this project started as a way to provide a comprehensive development stack. However, the "fat container" approach (running multiple processes like SSH, Cron, and Supervisor in a single container) proved inflexible and difficult to maintain.

### Legacy Management (`bin/` & `composer.json`)
Historically, this project included a set of management scripts in `bin/` (e.g., `xampp-start`, `xampp-env`). These were distributed via `composer.json` to allow easy installation. While these files remain in the repository for historical reference, they are **deprecated**.

### Current State
The project is currently undergoing a major refactoring:
*   **Migration**: Moving from legacy `src/*` images to a cleaner structure under `docker/*`.
*   **Decoupling**: Splitting services into dedicated containers (`xampp/base`, `xampp/php`, `xampp/httpd`, etc.).
*   **Management**: The legacy `bin/*` scripts have been superseded by [kaluzki/env](https://github.com/kaluzki/env) for better environment management.

> **Note**: Experimental support for PHP 8.1 (since Feb 2024), 8.3 (since Nov 2024), and 8.4 (since Jul 2025) based on the legacy `webdevops` architecture is available. These images were available on Docker Hub for some time but were only recently committed to the repository.

## Docker Hub

Official images are published and maintained at: [https://hub.docker.com/u/xampp](https://hub.docker.com/u/xampp)

## Directory Structure

*   `docker/`: Contains the source for modern, modular Docker images.
    *   `base/`: Base image with common configurations.
    *   `php/`: PHP-FPM images.
    *   `httpd/`: Apache HTTPD images.
    *   `node/`: Node.js development images.
*   `src/`: Legacy monolithic images (deprecated).
*   `bin/`: Legacy management scripts (deprecated).

## Usage

It is recommended to use [kaluzki/env](https://github.com/kaluzki/env) to manage your development environment using these images.

### Example Configuration

The following `compose.yml` demonstrates how to set up a PHP-FPM and Apache environment using Unix sockets for communication. Note that containers run as non-root users.

```yaml
networks:
  default:
    # Use an external network managed by kaluzki/env or similar
    name: ${ENV_NET-env}
    external: true

volumes:
  # Shared volume for Unix socket communication between PHP-FPM and Apache
  php-socket:

services:
  php:
    image: xampp/php
    hostname: ${COMPOSE_PROJECT_NAME}-php
    volumes:
      - .:/app
      # Mount the socket volume to allow Apache to communicate with PHP-FPM
      - php-socket:/var/run/php

  httpd:
    image: xampp/httpd
    depends_on:
      - php
    hostname: ${COMPOSE_PROJECT_NAME}-httpd
    volumes:
      - .:/app
      # Mount the socket volume to access the PHP-FPM socket
      - php-socket:/var/run/php
    labels:
      # Traefik configuration for reverse proxying
      - traefik.enable=true
      - traefik.http.routers.${COMPOSE_PROJECT_NAME}-httpd.entrypoints=443
      - traefik.http.routers.${COMPOSE_PROJECT_NAME}-httpd.tls=true
      - traefik.http.routers.${COMPOSE_PROJECT_NAME}-httpd.rule=Host(`${ENV_URL:-${COMPOSE_PROJECT_NAME}.app.localhost}`)
```

## License

See [LICENSE](LICENSE) file.

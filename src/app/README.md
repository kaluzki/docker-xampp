# XAMPP Legacy App Image (`xampp/app`)

⚠️ **DEPRECATED**: This image follows the "fat container" approach (Apache and PHP in a single process). It has been superseded by the new modular architecture (`xampp/php` + `xampp/httpd`).

## Overview
Based on `webdevops/php-apache-dev`, these images are heavily customized to provide an "out-of-the-box" full-stack development experience. While the upstream image provides the base, `xampp/app` adds significant tooling and configurations that were either not yet integrated or rejected in the upstream repository.

### Key Enhancements over Upstream (webdevops)
Unlike the standard `webdevops` images, this stack includes:

*   **Graceful Shutdown (SIGTERM Handling)**:
    Unlike the upstream images, `xampp/app` implements a robust `SIGTERM` trap in the entrypoint. This ensures that when a container is stopped, all **Teardown Entrypoints** are executed.
    *   **The Problem**: In the official `webdevops` images, containers often fail to restart automatically after a system reboot (e.g. server crash or scheduled maintenance), requiring a manual `docker-compose down && up`.
    *   **The Fix**: This image ensures a clean state upon shutdown, allowing Docker's `restart: always` policy to work reliably. This fix was merged in **[webdevops/Dockerfile#333](https://github.com/webdevops/Dockerfile/pull/333)** but later reverted upstream because it could interfere with interactive shell usage (`-ti bash`). This fork retains the fix to prioritize production stability.
*   **Gosu SUID Security-Lock**:
    The SUID bit of `/sbin/gosu` is dynamically managed. It is removed during provisioning and only restored during the teardown phase. This hardening ensures the container remains consistent even after unexpected shutdowns.
*   **Advanced Database Support**:
    *   **MySQL/MariaDB**: Integrated clients tailored to the OS distribution (Buster/Stretch).
    *   **MSSQL (Microsoft SQL Server)**: Full support including `msodbcsql17` drivers and PHP extensions (`sqlsrv`, `pdo_sqlsrv`), with OpenSSL optimizations for legacy connections.
*   **Integrated Node.js Stack**:
    *   Global **NVM** (Node Version Manager) installation in `/opt/nvm`.
    *   Pre-installed **Node.js LTS** (v20.11.1+) for frontend tooling.
*   **Developer Experience (UX)**:
    *   **Sexy Bash Prompt**: A highly informative shell prompt with real-time Git status.
    *   **Xdebug Wrapper**: A dedicated `xdebug` script to run PHP with Xdebug enabled on-demand.
    *   **Smart Provisioning**: Automatic removal of debug extensions when `DOCKER_XAMPP_BIN_ENV=prod` is set.

## Build Information
These images were built using the logic found in the `webdevops-php84` branch state. They represent a mature version of the monolithic architecture before the project shifted towards the current modular `docker/` structure.

## Available Tags (Experimental Support)
These images were available on Docker Hub long before being officially committed to the current repository:
*   **PHP 8.4** (since Jul 2025)
*   **PHP 8.3** (since Nov 2024)
*   **PHP 8.1 / 8.2** (since Feb 2024)
*   **Legacy Versions**: 8.0, 7.4, 7.3, 7.2, 7.1, 7.0, 5.6

## Usage
```bash
docker run -d -p 80:80 -v .:/app xampp/app:8.4
```

### ⚠️ Known Issue: Automatic Restarts & Host Reboots
Despite the integrated `SIGTERM` trap and teardown logic, these legacy images may still fail to restart automatically after a host system reboot or OS update.

*   **The Cause**: If Docker kills the container (`SIGKILL`) before the teardown script finishes restoring the `gosu` SUID bit, the container's filesystem remains in a "locked" state. On the next boot, the entrypoint will lack the necessary permissions to start.
*   **The Workaround**: If the container enters a crash loop or fails to start after a reboot, you must perform an explicit:
    ```bash
    docker-compose down && docker-compose up -d
    ```
    This recreates the container from the image layers and restores the correct SUID permissions.

## Migration Path
We highly recommend migrating to the modern modular stack for better performance and security:
1. Use **[xampp/php](https://hub.docker.com/r/xampp/php)** for application logic.
2. Use **[xampp/httpd](https://hub.docker.com/r/xampp/httpd)** for the web server.
3. Manage your environment with **[kaluzki/env](https://github.com/kaluzki/env)**.

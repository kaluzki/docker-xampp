# XAMPP Base Image (`xampp/base`)

The common foundation for all modern images in the XAMPP Docker stack.

## Overview
Based on `debian:trixie-slim`, this image provides a standardized environment for development and production containers. It focuses on essential tooling, security, and extensibility.

## Key Features

*   **Modern OS Base**: Built on Debian Trixie (Slim), offering access to current packages and a minimal footprint.
*   **Security (Non-Root)**: Establishes a standard `app` user (UID 1000) and ensures essential directories (`/app`, `/opt`, `/resources`) are owned by this user.
*   **Essential Development Tools**:
    *   **Git**: Pre-installed for version control operations within containers.
    *   **Curl & Ca-certificates**: For secure networking and asset fetching.
    *   **Iproute2**: Essential networking utilities.
*   **Developer UX**:
    *   **Starship Prompt**: A fast, cross-shell prompt installed globally.
    *   **Bash Completion**: Configured for a more productive shell experience.
*   **Job Scheduling**: Includes **Ofelia**, a modern Docker-native job scheduler.
*   **Extensible Initialization**: Supports custom shell scripts in `/etc/xampp.d/*.sh`, which are automatically sourced during shell startup.

## Usage
This image is intended as a base for other images (e.g., `xampp/php`, `xampp/httpd`).

```dockerfile
FROM xampp/base
# Add your specialized configurations here
```

## Maintenance
Part of the [XAMPP Docker project](https://github.com/kaluzki/docker-xampp).

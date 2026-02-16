# Agentic Context & Project Analysis

This file provides comprehensive instructions, architectural overview, and current status for AI agents working on the XAMPP Docker project.

## 🎯 Project Goals & Vision

*   **Modularization**: Transitioning from monolithic "fat" containers (legacy `src/`) to a decoupled, service-oriented architecture (`docker/`).
*   **Modernization**: Adopting current best practices for Docker (multi-stage builds, non-root execution), PHP (FPM, modern extensions), and Node.js.
*   **Maintainability**: Simplifying configuration by removing complex internal startup scripts and utilizing external environment management.

## 🏗 Architecture Overview

**Pattern:** Modular Service-Oriented Architecture (SOA)

### Core Components (`docker/`)
*   **`xampp/base`**: The foundation image (Debian Trixie Slim). Includes `starship` prompt, `git`, and sets up the non-root `app` user (UID 1000).
*   **`xampp/php`**: Specialized PHP-FPM images (8.1 - 8.5). Uses `install-php-extensions`, includes Composer and RoadRunner. Supports dynamic Xdebug via `APP_ENV`.
*   **`xampp/httpd`**: Optimized Apache 2.4 image. Configured to proxy PHP requests to FPM via Unix sockets.
*   **`xampp/node`**: Node.js environment managed via NVM.
*   **`xampp/dosbox`**: (Experimental) Legacy support environment.

### Communication & Security
*   **IPC**: PHP-FPM and Apache communicate via Unix sockets (`/var/run/php/php-fpm.sock`) shared through volumes for maximum performance.
*   **Permissions**: Mandatory non-root execution across all modern images.
*   **Reverse Proxy**: Designed to work seamlessly with Traefik (HTTPS termination, routing).

## 🛠 Commands & Automation

### Build Commands
*   **Build Base Image**: `docker build docker/base -f docker/base/Dockerfile -t xampp/base`
*   **Build PHP Image**: `docker build docker/php -f docker/php/Dockerfile -t xampp/php:8.2`
*   **Clean Build**: Add `--no-cache` to ensure all extensions and updates are fresh.
*   **Linting**: Use `hadolint` for Dockerfiles. Command: `hadolint <path_to_dockerfile>`.

### Test Commands
*   **Project Tests**: Currently a placeholder in `tests/`. 
*   **Single Image Verification**: `docker run --rm -ti xampp/base bash -c "starship --version"`
*   **Check PHP Extensions**: `docker run --rm xampp/php:8.2 php -m`

## 📝 Code Style & Guidelines

### Dockerfiles
*   **Base Image**: Always use `debian:trixie-slim` or the local `xampp/base`.
*   **Multi-Stage**: Use multi-stage builds to keep production images minimal.
*   **Non-Root**: Always create and switch to a non-root user (usually `app` with UID 1000).
*   **Layer Optimization**: Combine `apt-get update`, `install`, and cleanup in a single `RUN` block using Here-Documents (`<<EOF`).
*   **Extensions**: Use the `install-php-extensions` script for all PHP modules to handle dependencies automatically.
*   **Labels**: Include `org.opencontainers.image.vendor` and `org.opencontainers.image.source`.

### Shell Scripts & Integration
*   **Shebang**: Use `#!/usr/bin/env bash`.
*   **Safety**: Start scripts with `set -euxo pipefail`.
*   **Modular Configs**: Place initialization logic in `/etc/xampp.d/*.sh` instead of monolithic entrypoints.
*   **Formatting**: Use 2 spaces for indentation in Dockerfiles and scripts.

### Naming Conventions
*   **Images**: Follow `xampp/<service>` pattern.
*   **Variables**: Use `APP_` prefix for application-specific environment variables (e.g., `APP_ENV`, `APP_DOCUMENT_ROOT`).
*   **Dockerfiles**: Name them `Dockerfile` in specific subdirectories or `<version>.Dockerfile` in legacy `src/`.

### Error Handling
*   **Exit Codes**: Ensure all scripts return non-zero exit codes on failure.
*   **Validation**: Validate required environment variables at the start of entrypoint scripts.

## 🛠 Key Constraints & Preferences

1.  **Image Management**:
    *   Official Hub: `https://hub.docker.com/u/xampp`.
    *   Target: Modern development MUST happen in the `docker/` directory.
    *   Legacy: `src/` is deprecated but maintained for historical reference.

2.  **Environment Management**:
    *   **Externalize**: Do not use or modify internal scripts in `bin/` (deprecated).
    *   **Primary Tool**: Use [kaluzki/env](https://github.com/kaluzki/env) for environment orchestration.
    *   **Configuration**: Use environment variables instead of hardcoded configs.

3.  **Docker Best Practices**:
    *   Avoid multi-process containers (No Supervisor/SSH/Cron inside the app container).
    *   Minimize layers by grouping related commands.
    *   Always use `STOPSIGNAL SIGQUIT` for PHP-FPM images.

## 📊 Current Status & Roadmap

*   ✅ Core images (`base`, `php`, `httpd`) functional.
*   ⚠️ Migration of legacy PHP versions (5.6 - 7.4) to modular stack pending.
*   ⚠️ Implementation of automated integration tests in `tests/` required.

---

## 🧠 Patterns & Lessons Learned

### Efficient Tool Integration (The "Builder-Extractor" Pattern)
Instead of polluting the final image with build dependencies (curl, unzip, compilers, package managers), use a dedicated builder stage.

**Concept:**
1.  **Base System Stage**: Define shared runtime dependencies (e.g., `curl`, `ca-certificates`) to be used by both builder and final stages.
2.  **Builder Stage**: Inherit from `base-system`. Install tools/compilers (e.g., `mise`, `cargo`, `npm`) and build/download artifacts.
3.  **Extraction**: Locate the *actual* binary or artifact and copy it to a clean output directory (e.g., `/out` or `/mise`).
    *   *Tip for Mise:* Use `mise which <binary>` to find the executable, as shims don't work standalone.
4.  **Final Stage**: Inherit from `base-system`. Copy *only* the artifacts from the builder stage.

### Caching Strategy
Maximize build performance by caching package manager directories and download folders.

*   **Syntax:** Use `--mount=type=cache,target=<path>` in `RUN` instructions.
*   **Targets:**
    *   **APT:** `/var/cache/apt` and `/var/lib/apt` (locks packages)
    *   **Mise/Tools:** `/root/.cache/mise` (metadata) and `/root/.local/share/mise` (downloads/installs)
    *   **General:** Any directory where a package manager stores widely reused data.

### Configuration UX (Progressive Enhancement)
When designing configuration variables in maintenance scripts (e.g., `TOOLS="..."`), prioritize developer experience (DX) through iterative refinement.

*   **Start Robust:** Begin with an explicit format that handles all edge cases (e.g., `package:binary`).
*   **Simplify Common Case:** Introduce "Convention over Configuration" for the happy path (e.g., `package` implies `binary=package`).
*   **Retain Flexibility:** Ensure the simplified syntax still supports the complex cases (mixed list: `bat ripgrep:rg`).
*   **Implementation:** Use shell parameter expansion (`${var%%:*}`) to handle parsing logic inline, avoiding external dependencies like `sed` or `awk`.

---
*Last updated: 2026-02-16*

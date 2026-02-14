# Agentic Context & Project Analysis

This file provides comprehensive instructions, architectural overview, and current status for AI agents working on the XAMPP Docker project. It consolidates information from `AGENTS.md`, `GEMINI.md`, and `ANALYSIS.md`.

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

## 🛠 Key Constraints & Preferences

1.  **Image Management**:
    *   Official Hub: `https://hub.docker.com/u/xampp`.
    *   Target: Modern development MUST happen in the `docker/` directory.
    *   Legacy: `src/` is deprecated but maintained for historical reference.

2.  **Environment Management**:
    *   **Externalize**: Do not use or modify internal scripts in `bin/` (deprecated).
    *   **Primary Tool**: Use [kaluzki/env](https://github.com/kaluzki/env) for environment orchestration.
    *   **Configuration**: Use environment variables (e.g., `APP_DOCUMENT_ROOT`, `APP_ENV`) instead of hardcoded configs.

3.  **Docker Best Practices**:
    *   Avoid multi-process containers (No Supervisor/SSH/Cron inside the app container).
    *   Use multi-stage builds to keep image sizes minimal.
    *   Ensure Dockerfiles are clean, documented, and use `install-php-extensions` for PHP builds.

## 📊 Current Analysis & Status (Feb 2026)

### Strengths
*   ✅ Clear separation between legacy and modern stacks.
*   ✅ Security-focused (non-root) and developer-friendly (starship, bash-completion).
*   ✅ Flexible PHP versioning (up to 8.5) and easy extension management.

### Technical Debt / Pending Tasks
*   ⚠️ **Migration**: Remaining legacy features in `src/` need to be evaluated and moved to the modular stack.
*   ⚠️ **Testing**: The `tests/` directory is currently a placeholder. Needs automated image verification.
*   ⚠️ **Cleanup**: Deprecated `bin/` and legacy `composer.json` should be removed once full parity with `kaluzki/env` is confirmed.

## 🚀 Common Tasks for Agents

*   **Add PHP Extension**: Update the `install-php-extensions` list in `docker/php/Dockerfile`.
*   **Update PHP Version**: Change `ARG from=php:X.Y-fpm` and rebuild.
*   **Modify Web Server**: Adjust `docker/httpd/xampp.conf` for new modules or routing rules.

---
*Last updated: 2026-02-14*

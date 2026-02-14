# Changelog

## Dec 2025 - Feb 2026: Architecture Overhaul
*   **Refactoring**: Split monolithic images into modular components (`xampp/base`, `xampp/php`, `xampp/httpd`, `xampp/node`, `xampp/dosbox`).
*   **Features**:
    *   Added `APP_DOCUMENT_ROOT` for dynamic document root configuration.
    *   Added support for Unix sockets between PHP-FPM and Apache.
    *   Enhanced HTTPS support (X-Forwarded-Proto handling).
    *   Added GD library and essential HTTPD modules.
*   **Maintenance**: Updated copyright year range.

## Experimental PHP Versions (Legacy Architecture)
*   **Images**: Added experimental support for PHP 8.1 (Feb 2024), 8.3 (Nov 2024), and 8.4 (Jul 2025) based on the legacy `webdevops` architecture.
*   **Note**: These images were available on Docker Hub for some time but were only recently committed to the repository. They represent the older monolithic approach.

## 2022 - Feb 2024: Workflow & Maintenance
*   **Images**: Added `xampp/app:8.2`.
*   **Updates**: Upgraded to Node v20.11.1 and npm v10.2.4.
*   **CI/CD**: Introduced GitHub Actions workflows for Docker builds.
*   **Fixes**: MSSQL provision script updates, `DOCKER_XAMPP_BIN_ENV` fixes.

## Dec 2020 - Oct 2021: Major Version Upgrades
*   **Images**: Added `xampp/app:8.0`.
*   **Updates**:
    *   Upgraded Node from v12 to v14, then to v16.
    *   Configured Xdebug >= 3.0.
*   **Fixes**: Enabled PHP extensions in official images.

## Nov 2019: Modernization & Refactoring
*   **Infrastructure**: Upgraded to Traefik 2.0 with self-signed certificates.
*   **Images**: Added `app:7.4.Dockerfile`.
*   **Updates**: Upgraded to Node 12.x.
*   **Scripts**: Refactored `xampp-*` scripts, improved environment variable handling (`XDEBUG_REMOTE_HOST`).

## Apr 2019 - May 2019: Enhancements & Tooling
*   **Development**: Added `xampp-up-du` for dev mode container creation.
*   **Images**: Added PHP 7.* support, SQL Server extensions (`sqlsrv`, `pdo_sqlsrv`).
*   **Tools**: Upgraded to Node v11, installed global CLI tools (Vue, Quasar).
*   **Configuration**: Enabled Xdebug profiler by default, HTTPS bash prompt.

## Nov 2018 - Dec 2018: Project Initialization & Foundation
*   **Setup**: Initial repository creation (`docker-xampp`).
*   **Scripts**: Created `xampp-start`, `xampp-stop`, `xampp-env` management scripts.
*   **Images**: Added `xampp/app:5.6` and MySQL container support.
*   **Integration**: Registered bash scripts in `composer.json`.

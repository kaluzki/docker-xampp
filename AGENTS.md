# Agentic Context

This file contains context and instructions for AI agents working on the XAMPP Docker project.

## Project Goals

*   **Modularization**: Transition from monolithic "fat" containers (legacy `src/`) to single-responsibility containers (`docker/`).
*   **Modernization**: Adopt current best practices for Docker, PHP, and Node.js development environments.
*   **Maintainability**: Simplify configuration and reduce dependencies on complex startup scripts.

## Key Constraints & Preferences

1.  **Image Management**:
    *   Official images are published to: `https://hub.docker.com/u/xampp`.
    *   New development should focus on the `docker/` directory.
    *   Legacy images in `src/` are deprecated but may still be referenced for historical context.

2.  **Environment Management**:
    *   Do **not** use or modify scripts in `bin/`. These are deprecated.
    *   The recommended way to manage the environment is via [kaluzki/env](https://github.com/kaluzki/env).
    *   Any new tooling or scripts should align with the philosophy of `kaluzki/env` (externalized management).
    *   `composer.json` was historically used to distribute `bin/` scripts but is now considered legacy/deprecated.

3.  **Architecture**:
    *   **Avoid** running multiple services (SSH, Cron, Supervisor) in a single container unless absolutely necessary.
    *   Prefer a sidecar or separate service approach (e.g., separate PHP-FPM and Apache containers).
    *   Use Unix sockets for inter-container communication where performance is critical (e.g., PHP-FPM <-> Apache).

4.  **Configuration**:
    *   Use environment variables for runtime configuration (e.g., `APP_DOCUMENT_ROOT`).
    *   Keep Dockerfiles clean and readable. Use multi-stage builds if appropriate to reduce image size.

## Current Focus

*   Refining the `docker/base`, `docker/php`, and `docker/httpd` images.
*   Ensuring seamless integration with `kaluzki/env`.
*   Documentation updates to reflect the shift away from legacy scripts.

## Pending Tasks

### 1. Verify Docker Hub Image Dates
*   **Goal**: Find the exact push dates for the experimental PHP images (`xampp/app:8.4`, `xampp/app:8.3`, `xampp/app:8.1`) on Docker Hub (`https://hub.docker.com/u/xampp`).
*   **Action**: Update `CHANGELOG.md` and `README.md` with the correct dates instead of the commit date (Feb 2026).
*   **Context**: These images were available on Docker Hub for some time but were only recently committed to the repository. Note that the Dockerfiles use `webdevops/php-apache-dev` as base images, but the target images are named `xampp/app:X.Y`.

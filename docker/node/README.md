# XAMPP Node.js Image (`xampp/node`)

A flexible Node.js development image based on the XAMPP foundation.

## Overview
Built on top of `xampp/base`, this image uses **NVM** (Node Version Manager) to manage Node.js versions, providing a consistent and customizable environment for frontend builds and JavaScript-based services.

## Key Features

*   **NVM-Powered**: Uses NVM for easy Node.js and npm version management.
*   **LTS by Default**: Comes pre-installed with the latest Node.js Long-Term Support (LTS) version.
*   **Persistent Configuration**: Node.js and npm are automatically available in the shell via a custom initialization script in `/etc/xampp.d/30-nvm.sh`.
*   **Non-Root Execution**: Inherits the `app` user (UID 1000) from the base image.

## Usage

```bash
docker run --rm -it xampp/node node -v
```

Or within a `compose.yml`:

```yaml
services:
  node:
    image: xampp/node
    volumes:
      - .:/app
    command: npm run build
```

## Maintenance
Maintained as part of the modular XAMPP Docker project.

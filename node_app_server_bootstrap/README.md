# Node App Server Bootstrap Collection

This Ansible collection provides a streamlined way to set up a VPS with a **Node.js + PM2 + Nginx stack**, suitable for modern web applications such as **Vite**, **Next.js**, or any **Node.js backend applications**.

## Features

- Installs and configures **Nginx** for serving static assets or reverse proxy.
- Installs **Node.js** (official NodeSource packages).
- Installs **PM2** globally to manage Node.js applications.
- Supports **install** and **uninstall** workflows.
- Idempotent roles, safe to run multiple times.
- Dependencies handled (e.g., PM2 depends on Node.js).

## Requirements

- Ubuntu 20.04+ / Debian-based distributions
- Ansible 2.9+
- `sudo` access for installation tasks

## Roles

### nginx

Handles installation and configuration of Nginx.

- Start/stop service
- Install/uninstall stack

### nodejs

Installs Node.js from the official NodeSource repository.

- Set version (default: Node.js 18)
- Install/uninstall
- Idempotent repo and GPG key management

### pm2

Installs PM2 globally via npm.

- Requires Node.js role
- Install/uninstall PM2
- Clean logs and directories on uninstall

## Usage

### Install Stack

```yaml
- hosts: localhost
  become: true
  vars:
    nginx_state: present
    node_state: present
    pm2_state: present
  roles:
    - roles/nginx
    - roles/nodejs
    - roles/pm2
```

### Uninstall Stack

```yaml
- hosts: localhost
  become: true
  vars:
    nginx_state: absent
    node_state: absent
    pm2_state: absent
  roles:
    - roles/pm2
    - roles/nodejs
    - roles/nginx
```

> Note: Uninstall runs in reverse order to safely remove PM2 before Node.js, and Node.js before Nginx.

## Testing

Test playbooks are included in the `tests/` directory:

- `test-install.yml` - Tests installation workflow
- `test-uninstall.yml` - Tests uninstallation workflow
- Inventory: `inventory.ini` for local testing

Run tests:

```bash
ansible-playbook -i tests/inventory.ini tests/test-install.yml --ask-become-pass
ansible-playbook -i tests/inventory.ini tests/test-uninstall.yml --ask-become-pass
```

## Notes

- Roles are referenced using relative paths (`roles/nginx`) to avoid dependency on Galaxy.
- PM2 role depends on Node.js; ensure Node.js role is executed before PM2.
- Idempotent design ensures safe multiple executions.

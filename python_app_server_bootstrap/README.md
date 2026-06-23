# Python App Server Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.python__app__server__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/python_app_server_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap a production-ready VPS with a **Python + pip + Gunicorn + Nginx** stack. Perfect for deploying any Python web application like Django, Flask, FastAPI, etc.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [nginx](#nginx)
  - [python](#python)
  - [gunicorn](#gunicorn)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Complete Stack**: Installs and configures Nginx, Python, pip, and Gunicorn in one go
- **WSGI/ASGI Ready**: Gunicorn configured for process management
- **Flexible Workflows**: Supports both install and uninstall operations
- **Idempotent Design**: Safe to run multiple times without side effects
- **Production Ready**: Suitable for VPS deployments on DigitalOcean, Linode, AWS EC2, etc.

## Requirements

| Requirement | Version |
|-------------|---------|
| Ansible | 2.9+ |
| Python | 3.6+ |
| Target OS | Ubuntu 20.04+ / Debian 10+ |

**Target Host Requirements:**
- SSH access with `sudo` privileges
- Internet connectivity for package downloads

## Installation

### From Ansible Galaxy

```bash
ansible-galaxy collection install marcuwynu23.python_app_server_bootstrap
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/python_app_server_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-python_app_server_bootstrap-1.0.0.tar.gz
```

## Quick Start

### 1. Create an Inventory File

Create `inventory.ini`:

```ini
[webservers]
your-server-ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa

[webservers:vars]
ansible_python_interpreter=/usr/bin/python3
```

### 2. Create a Playbook

Create `setup.yml`:

```yaml
---
- name: Bootstrap Python Application Server
  hosts: webservers
  become: true
  vars:
    nginx_state: present
    python_state: present
    gunicorn_state: present
  roles:
    - marcuwynu23.python_app_server_bootstrap.nginx
    - marcuwynu23.python_app_server_bootstrap.python
    - marcuwynu23.python_app_server_bootstrap.gunicorn
```

### 3. Run the Playbook

```bash
ansible-playbook -i inventory.ini setup.yml
```

## Roles

### nginx

Installs and configures Nginx web server.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `nginx_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Nginx from official repositories
- Manages service start/stop/restart
- Handles complete removal on uninstall

---

### python

Installs Python, pip, and development packages.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `python_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Python 3
- Installs pip and venv
- Installs common development packages
- Clean removal on uninstall

---

### gunicorn

Installs Gunicorn WSGI server.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `gunicorn_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Gunicorn via pip
- Requires Python role
- Clean removal on uninstall

## License

This project is licensed under the MIT License.

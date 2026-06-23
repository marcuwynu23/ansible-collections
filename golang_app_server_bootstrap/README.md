# Go App Server Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.golang__app__server__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/golang_app_server_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap a production-ready VPS with a **Go + Nginx** stack. Perfect for deploying any Go web application.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [nginx](#nginx)
  - [golang](#golang)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Complete Stack**: Installs and configures Nginx and Go compiler in one go
- **Reverse Proxy Ready**: Nginx configured for serving Go applications
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
ansible-galaxy collection install marcuwynu23.golang_app_server_bootstrap
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/golang_app_server_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-golang_app_server_bootstrap-1.0.0.tar.gz
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
- name: Bootstrap Go Application Server
  hosts: webservers
  become: true
  vars:
    nginx_state: present
    golang_state: present
  roles:
    - marcuwynu23.golang_app_server_bootstrap.nginx
    - marcuwynu23.golang_app_server_bootstrap.golang
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

### golang

Installs Go compiler from Google's official repository.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `golang_state` | `present` | Set to `present` to install, `absent` to uninstall |
| `golang_version` | `1.22` | Go major version to install (Ubuntu only) |

**Features:**
- Installs Go compiler
- Clean removal on uninstall

## License

This project is licensed under the MIT License.

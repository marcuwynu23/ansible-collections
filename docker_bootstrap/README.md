# Docker Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.docker__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/docker_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap a production-ready VPS with **Docker Engine**.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [docker](#docker)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Complete Docker Engine Installation**: Installs Docker CE from official Docker repositories
- **Docker Compose**: Optional installation of Docker Compose (v2 plugin)
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
ansible-galaxy collection install marcuwynu23.docker_bootstrap
```

### With a Requirements File

Create a `requirements.yml`:

```yaml
collections:
  - name: marcuwynu23.docker_bootstrap
    version: ">=1.0.0"
```

Then install:

```bash
ansible-galaxy collection install -r requirements.yml
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/docker_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-docker_bootstrap-1.0.0.tar.gz
```

## Quick Start

### 1. Create an Inventory File

Create `inventory.ini`:

```ini
[docker_servers]
your-server-ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa

[docker_servers:vars]
ansible_python_interpreter=/usr/bin/python3
```

### 2. Create a Playbook

Create `setup.yml`:

```yaml
---
- name: Bootstrap Docker Server
  hosts: docker_servers
  become: true
  vars:
    docker_state: present
    docker_compose_state: present
  roles:
    - marcuwynu23.docker_bootstrap.docker
```

### 3. Run the Playbook

```bash
ansible-playbook -i inventory.ini setup.yml
```

## Roles

### docker

Installs Docker CE from official Docker repositories.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `docker_state` | `present` | Set to `present` to install, `absent` to uninstall |
| `docker_compose_state` | `present` | Set to `present` to install, `absent` to uninstall Docker Compose v2 |

**Features:**
- Installs Docker CE from official Docker repositories
- Adds Docker GPG keys and repository configuration
- Optional Docker Compose v2 plugin installation
- Manages Docker service
- Clean removal on uninstall

## Configuration

### State Variables

All roles use a consistent state variable pattern:

```yaml
# Install components
docker_state: present
docker_compose_state: present

# Uninstall components
docker_state: absent
docker_compose_state: absent
```

## Usage Examples

### Install Docker Only

```yaml
---
- name: Install Docker
  hosts: docker_servers
  become: true
  vars:
    docker_state: present
    docker_compose_state: absent
  roles:
    - marcuwynu23.docker_bootstrap.docker
```

### Uninstall Everything

```yaml
---
- name: Uninstall Docker
  hosts: docker_servers
  become: true
  vars:
    docker_state: absent
    docker_compose_state: absent
  roles:
    - marcuwynu23.docker_bootstrap.docker
```

## Testing

Test playbooks are included in the `tests/` directory for validating the collection.

### Running Tests Locally

```bash
# Test installation
ansible-playbook -i tests/inventory.ini.test tests/test-install.yml --ask-become-pass

# Test uninstallation
ansible-playbook -i tests/inventory.ini.test tests/test-uninstall.yml --ask-become-pass
```

## Troubleshooting

### Common Issues

**Permission Denied:**
```
FAILED! => "msg": "Missing sudo password"
```
**Solution:** Add `--ask-become-pass` or configure passwordless sudo.

---

**SSH Connection Failed:**
```
UNREACHABLE! => "msg": "Failed to connect to the host"
```
**Solution:** Verify SSH credentials and ensure the target host is accessible.

---

**Docker Repository Issues:**
```
FAILED! => "msg": "Failed to update apt cache"
```
**Solution:** Ensure the target system has internet access and can reach Docker's repositories.

### Debug Mode

Run playbooks with verbose output for debugging:

```bash
ansible-playbook -i inventory.ini setup.yml -vvv
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Mark Wayne** - [marcuwynu23](https://galaxy.ansible.com/marcuwynu23)

---

## Support

If you find this collection helpful, please consider giving it a star on [GitHub](https://github.com/marcuwynu23/ansible-collections) and rating it on [Ansible Galaxy](https://galaxy.ansible.com/marcuwynu23/docker_bootstrap).

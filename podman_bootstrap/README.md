# Podman Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.podman__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/podman_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap a production-ready VPS with **Podman**.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [podman](#podman)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Complete Podman Installation**: Installs Podman from official repositories
- **Podman Compose**: Optional installation of Podman Compose
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
ansible-galaxy collection install marcuwynu23.podman_bootstrap
```

### With a Requirements File

Create a `requirements.yml`:

```yaml
collections:
  - name: marcuwynu23.podman_bootstrap
    version: ">=1.0.0"
```

Then install:

```bash
ansible-galaxy collection install -r requirements.yml
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/podman_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-podman_bootstrap-1.0.0.tar.gz
```

## Quick Start

### 1. Create an Inventory File

Create `inventory.ini`:

```ini
[podman_servers]
your-server-ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa

[podman_servers:vars]
ansible_python_interpreter=/usr/bin/python3
```

### 2. Create a Playbook

Create `setup.yml`:

```yaml
---
- name: Bootstrap Podman Server
  hosts: podman_servers
  become: true
  vars:
    podman_state: present
    podman_compose_state: present
  roles:
    - marcuwynu23.podman_bootstrap.podman
```

### 3. Run the Playbook

```bash
ansible-playbook -i inventory.ini setup.yml
```

## Roles

### podman

Installs Podman from official repositories.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `podman_state` | `present` | Set to `present` to install, `absent` to uninstall |
| `podman_compose_state` | `present` | Set to `present` to install, `absent` to uninstall Podman Compose |

**Features:**
- Installs Podman from official repositories
- Optional Podman Compose installation
- Manages Podman service
- Clean removal on uninstall

## Configuration

### State Variables

All roles use a consistent state variable pattern:

```yaml
# Install components
podman_state: present
podman_compose_state: present

# Uninstall components
podman_state: absent
podman_compose_state: absent
```

## Usage Examples

### Install Podman Only

```yaml
---
- name: Install Podman
  hosts: podman_servers
  become: true
  vars:
    podman_state: present
    podman_compose_state: absent
  roles:
    - marcuwynu23.podman_bootstrap.podman
```

### Uninstall Everything

```yaml
---
- name: Uninstall Podman
  hosts: podman_servers
  become: true
  vars:
    podman_state: absent
    podman_compose_state: absent
  roles:
    - marcuwynu23.podman_bootstrap.podman
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

If you find this collection helpful, please consider giving it a star on [GitHub](https://github.com/marcuwynu23/ansible-collections) and rating it on [Ansible Galaxy](https://galaxy.ansible.com/marcuwynu23/podman_bootstrap).

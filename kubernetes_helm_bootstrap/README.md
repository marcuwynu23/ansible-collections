# Kubernetes + Helm Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.kubernetes__helm__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/kubernetes_helm_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap a VPS with **kubectl (Kubernetes CLI)** and **Helm** (package manager for Kubernetes).

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [kubectl](#kubectl)
  - [helm](#helm)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **kubectl Installation**: Installs Kubernetes CLI from official Kubernetes repositories
- **Helm Installation**: Installs Helm package manager from official Helm repositories
- **Flexible Workflows**: Supports both install and uninstall operations
- **Idempotent Design**: Safe to run multiple times without side effects
- **Dependency Management**: Helm depends on kubectl
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
ansible-galaxy collection install marcuwynu23.kubernetes_helm_bootstrap
```

### With a Requirements File

Create a `requirements.yml`:

```yaml
collections:
  - name: marcuwynu23.kubernetes_helm_bootstrap
    version: ">=1.0.0"
```

Then install:

```bash
ansible-galaxy collection install -r requirements.yml
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/kubernetes_helm_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-kubernetes_helm_bootstrap-1.0.0.tar.gz
```

## Quick Start

### 1. Create an Inventory File

Create `inventory.ini`:

```ini
[k8s_servers]
your-server-ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa

[k8s_servers:vars]
ansible_python_interpreter=/usr/bin/python3
```

### 2. Create a Playbook

Create `setup.yml`:

```yaml
---
- name: Bootstrap Kubernetes CLI and Helm
  hosts: k8s_servers
  become: true
  vars:
    kubectl_state: present
    helm_state: present
  roles:
    - marcuwynu23.kubernetes_helm_bootstrap.kubectl
    - marcuwynu23.kubernetes_helm_bootstrap.helm
```

### 3. Run the Playbook

```bash
ansible-playbook -i inventory.ini setup.yml
```

## Roles

### kubectl

Installs Kubernetes CLI (kubectl) from official Kubernetes repositories.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `kubectl_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs kubectl from official Kubernetes repositories
- Manages GPG keys and repository configuration
- Clean removal on uninstall

---

### helm

Installs Helm package manager from official Helm repositories.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `helm_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Helm from official Helm repositories
- Requires kubectl role (dependency)
- Clean removal on uninstall

**Dependencies:**
- `kubectl` role should be applied before `helm`

## Configuration

### State Variables

All roles use a consistent state variable pattern:

```yaml
# Install components
kubectl_state: present
helm_state: present

# Uninstall components
kubectl_state: absent
helm_state: absent
```

## Usage Examples

### Install kubectl Only

```yaml
---
- name: Install kubectl
  hosts: k8s_servers
  become: true
  vars:
    kubectl_state: present
    helm_state: absent
  roles:
    - marcuwynu23.kubernetes_helm_bootstrap.kubectl
```

### Install Everything

```yaml
---
- name: Install kubectl and Helm
  hosts: k8s_servers
  become: true
  vars:
    kubectl_state: present
    helm_state: present
  roles:
    - marcuwynu23.kubernetes_helm_bootstrap.kubectl
    - marcuwynu23.kubernetes_helm_bootstrap.helm
```

### Uninstall Everything

> **Important:** When uninstalling, roles should be applied in reverse order to handle dependencies correctly.

```yaml
---
- name: Uninstall kubectl and Helm
  hosts: k8s_servers
  become: true
  vars:
    helm_state: absent
    kubectl_state: absent
  roles:
    - marcuwynu23.kubernetes_helm_bootstrap.helm
    - marcuwynu23.kubernetes_helm_bootstrap.kubectl
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

If you find this collection helpful, please consider giving it a star on [GitHub](https://github.com/marcuwynu23/ansible-collections) and rating it on [Ansible Galaxy](https://galaxy.ansible.com/marcuwynu23/kubernetes_helm_bootstrap).

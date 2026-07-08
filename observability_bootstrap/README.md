# Observability Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.observability__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/observability_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap an observability stack on a VPS, including **Prometheus**, **Grafana**, **Loki**, **Promtail**, **Tempo**, and **OpenTelemetry Collector**.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [prometheus](#prometheus)
  - [grafana](#grafana)
  - [loki](#loki)
  - [promtail](#promtail)
  - [tempo](#tempo)
  - [opentelemetry](#opentelemetry)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Prometheus**: Time series database for metrics
- **Grafana**: Visualization and dashboarding
- **Loki**: Log aggregation system
- **Promtail**: Log collector for Loki
- **Tempo**: Distributed tracing backend
- **OpenTelemetry Collector**: Vendor-agnostic telemetry collection
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
ansible-galaxy collection install marcuwynu23.observability_bootstrap
```

### With a Requirements File

Create a `requirements.yml`:

```yaml
collections:
  - name: marcuwynu23.observability_bootstrap
    version: ">=1.0.0"
```

Then install:

```bash
ansible-galaxy collection install -r requirements.yml
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/observability_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-observability_bootstrap-1.0.0.tar.gz
```

## Quick Start

### 1. Create an Inventory File

Create `inventory.ini`:

```ini
[observability_servers]
your-server-ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa

[observability_servers:vars]
ansible_python_interpreter=/usr/bin/python3
```

### 2. Create a Playbook

Create `setup.yml`:

```yaml
---
- name: Bootstrap Observability Stack
  hosts: observability_servers
  become: true
  vars:
    prometheus_state: present
    grafana_state: present
    loki_state: present
    promtail_state: present
    tempo_state: present
    opentelemetry_state: present
  roles:
    - marcuwynu23.observability_bootstrap.prometheus
    - marcuwynu23.observability_bootstrap.grafana
    - marcuwynu23.observability_bootstrap.loki
    - marcuwynu23.observability_bootstrap.promtail
    - marcuwynu23.observability_bootstrap.tempo
    - marcuwynu23.observability_bootstrap.opentelemetry
```

### 3. Run the Playbook

```bash
ansible-playbook -i inventory.ini setup.yml
```

## Roles

### prometheus

Installs Prometheus time series database.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `prometheus_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Prometheus from official repositories
- Manages Prometheus service
- Clean removal on uninstall

---

### grafana

Installs Grafana visualization platform.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `grafana_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Grafana from official repositories
- Manages Grafana service
- Clean removal on uninstall

---

### loki

Installs Loki log aggregation system.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `loki_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Loki from official Grafana repositories
- Manages Loki service
- Clean removal on uninstall

---

### promtail

Installs Promtail log collector.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `promtail_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Promtail from official Grafana repositories
- Manages Promtail service
- Clean removal on uninstall

---

### tempo

Installs Tempo distributed tracing backend.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `tempo_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Tempo from official Grafana repositories
- Manages Tempo service
- Clean removal on uninstall

---

### opentelemetry

Installs OpenTelemetry Collector.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `opentelemetry_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs OpenTelemetry Collector from official repositories
- Manages OpenTelemetry Collector service
- Clean removal on uninstall

## Configuration

### State Variables

All roles use a consistent state variable pattern:

```yaml
# Install components
prometheus_state: present
grafana_state: present
loki_state: present
promtail_state: present
tempo_state: present
opentelemetry_state: present

# Uninstall components
prometheus_state: absent
grafana_state: absent
loki_state: absent
promtail_state: absent
tempo_state: absent
opentelemetry_state: absent
```

## Usage Examples

### Install Only Prometheus and Grafana

```yaml
---
- name: Install Prometheus and Grafana
  hosts: observability_servers
  become: true
  vars:
    prometheus_state: present
    grafana_state: present
    loki_state: absent
    promtail_state: absent
    tempo_state: absent
    opentelemetry_state: absent
  roles:
    - marcuwynu23.observability_bootstrap.prometheus
    - marcuwynu23.observability_bootstrap.grafana
```

### Uninstall Everything

```yaml
---
- name: Uninstall Observability Stack
  hosts: observability_servers
  become: true
  vars:
    opentelemetry_state: absent
    tempo_state: absent
    promtail_state: absent
    loki_state: absent
    grafana_state: absent
    prometheus_state: absent
  roles:
    - marcuwynu23.observability_bootstrap.opentelemetry
    - marcuwynu23.observability_bootstrap.tempo
    - marcuwynu23.observability_bootstrap.promtail
    - marcuwynu23.observability_bootstrap.loki
    - marcuwynu23.observability_bootstrap.grafana
    - marcuwynu23.observability_bootstrap.prometheus
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

If you find this collection helpful, please consider giving it a star on [GitHub](https://github.com/marcuwynu23/ansible-collections) and rating it on [Ansible Galaxy](https://galaxy.ansible.com/marcuwynu23/observability_bootstrap).

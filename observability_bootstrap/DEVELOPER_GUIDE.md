# Developer Guide

This guide covers how to develop, test, build, and publish the `marcuwynu23.observability_bootstrap` Ansible collection.

## Table of Contents

- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Creating Roles](#creating-roles)
- [Writing Tasks](#writing-tasks)
- [Testing](#testing)
- [Building the Collection](#building-the-collection)
- [Publishing to Ansible Galaxy](#publishing-to-ansible-galaxy)
- [Versioning](#versioning)
- [Best Practices](#best-practices)

---

## Development Setup

### Prerequisites

Ensure you have the following installed on your development machine:

| Tool | Version | Installation |
|------|---------|--------------|
| Python | 3.8+ | [python.org](https://www.python.org/downloads/) |
| Ansible | 2.9+ | `pip install ansible` |
| ansible-lint | Latest | `pip install ansible-lint` |
| Git | 2.0+ | [git-scm.com](https://git-scm.com/) |

---

## Project Structure

```
observability_bootstrap/
├── galaxy.yml
├── README.md
├── DEVELOPER_GUIDE.md
├── playbooks/
│   ├── install.yml
│   ├── uninstall.yml
│   └── inventory.ini.example
├── roles/
│   ├── nginx/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   ├── prometheus/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   ├── grafana/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   ├── loki/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   ├── promtail/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   ├── tempo/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   └── opentelemetry/
│       ├── tasks/
│       │   └── main.yml
│       ├── meta/
│       │   └── main.yml
│       ├── tests/
│       │   ├── test.yml
│       │   └── inventory.ini.test
│       └── README.md
└── tests/
    ├── test-install.yml
    ├── test-uninstall.yml
    └── inventory.ini.test
```

---

## Building the Collection

```bash
cd observability_bootstrap
ansible-galaxy collection build
```

---

## Publishing to Ansible Galaxy

```bash
export ANSIBLE_GALAXY_TOKEN=your_api_token
ansible-galaxy collection publish marcuwynu23-observability_bootstrap-*.tar.gz
```

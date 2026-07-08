# Developer Guide

This guide covers how to develop, test, build, and publish the `marcuwynu23.docker_bootstrap` Ansible collection.

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

### Setting Up Your Environment

```bash
# Clone the repository
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/docker_bootstrap

# Create a virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install development dependencies
pip install ansible ansible-lint yamllint
```

### Verify Installation

```bash
ansible --version
ansible-lint --version
```

---

## Project Structure

```
docker_bootstrap/
├── galaxy.yml                 # Collection metadata
├── README.md                  # User documentation
├── DEVELOPER_GUIDE.md         # This file
├── playbooks/
│   ├── install.yml            # Installation playbook
│   ├── uninstall.yml          # Uninstallation playbook
│   └── inventory.ini.example  # Example inventory
├── roles/
│   └── docker/
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

## Testing

### Running Role Tests

```bash
# Test docker role
ansible-playbook -i roles/docker/tests/inventory.ini.test roles/docker/tests/test.yml
```

### Running Integration Tests

```bash
# Test full installation
ansible-playbook -i tests/inventory.ini.test tests/test-install.yml --ask-become-pass
```

---

## Building the Collection

```bash
cd docker_bootstrap
ansible-galaxy collection build
```

---

## Publishing to Ansible Galaxy

```bash
export ANSIBLE_GALAXY_TOKEN=your_api_token
ansible-galaxy collection publish marcuwynu23-docker_bootstrap-*.tar.gz
```

---

## Versioning

This project follows [Semantic Versioning](https://semver.org/).

# Node App Server Bootstrap

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-marcuwynu23.node__app__server__bootstrap-blue.svg)](https://galaxy.ansible.com/marcuwynu23/node_app_server_bootstrap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible collection that provides a streamlined way to bootstrap a production-ready VPS with a **Node.js + PM2 + Nginx** stack. Perfect for deploying modern web applications such as **Next.js**, **Vite**, **Express**, or any **Node.js backend**.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Roles](#roles)
  - [nginx](#nginx)
  - [nodejs](#nodejs)
  - [pm2](#pm2)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Complete Stack**: Installs and configures Nginx, Node.js, and PM2 in one go
- **Reverse Proxy Ready**: Nginx configured for serving static assets or as a reverse proxy
- **Process Management**: PM2 for zero-downtime deployments and automatic restarts
- **Flexible Workflows**: Supports both install and uninstall operations
- **Idempotent Design**: Safe to run multiple times without side effects
- **Dependency Management**: Roles handle dependencies automatically (e.g., PM2 depends on Node.js)
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
ansible-galaxy collection install marcuwynu23.node_app_server_bootstrap
```

### With a Requirements File

Create a `requirements.yml`:

```yaml
collections:
  - name: marcuwynu23.node_app_server_bootstrap
    version: ">=1.0.0"
```

Then install:

```bash
ansible-galaxy collection install -r requirements.yml
```

### From Source

```bash
git clone https://github.com/marcuwynu23/ansible-collections.git
cd ansible-collections/node_app_server_bootstrap
ansible-galaxy collection build
ansible-galaxy collection install marcuwynu23-node_app_server_bootstrap-1.0.0.tar.gz
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
- name: Bootstrap Node.js Application Server
  hosts: webservers
  become: true
  vars:
    nginx_state: present
    node_state: present
    pm2_state: present
  roles:
    - marcuwynu23.node_app_server_bootstrap.nginx
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.pm2
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

### nodejs

Installs Node.js from the official NodeSource repository.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `node_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Installs Node.js 18.x LTS (default)
- Manages GPG keys and repository configuration
- Includes npm package manager
- Clean removal of repository on uninstall

---

### pm2

Installs PM2 process manager globally via npm.

**Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `pm2_state` | `present` | Set to `present` to install, `absent` to uninstall |

**Features:**
- Requires Node.js role (dependency)
- Global npm installation
- Cleans PM2 logs and directories on uninstall

**Dependencies:**
- `nodejs` role must be applied before `pm2`

## Configuration

### State Variables

All roles use a consistent state variable pattern:

```yaml
# Install components
nginx_state: present
node_state: present
pm2_state: present

# Uninstall components
nginx_state: absent
node_state: absent
pm2_state: absent
```

### Customizing for Different Environments

**Development:**

```yaml
- hosts: dev_servers
  become: true
  vars:
    nginx_state: present
    node_state: present
    pm2_state: present
  roles:
    - marcuwynu23.node_app_server_bootstrap.nginx
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.pm2
```

**Production with specific host groups:**

```yaml
- hosts: production
  become: true
  vars:
    nginx_state: present
    node_state: present
    pm2_state: present
  roles:
    - marcuwynu23.node_app_server_bootstrap.nginx
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.pm2
```

## Usage Examples

### Install Full Stack

```yaml
---
- name: Install Node.js Application Stack
  hosts: webservers
  become: true
  vars:
    nginx_state: present
    node_state: present
    pm2_state: present
  roles:
    - marcuwynu23.node_app_server_bootstrap.nginx
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.pm2
```

### Uninstall Full Stack

> **Important:** When uninstalling, roles should be applied in reverse order to handle dependencies correctly.

```yaml
---
- name: Uninstall Node.js Application Stack
  hosts: webservers
  become: true
  vars:
    pm2_state: absent
    node_state: absent
    nginx_state: absent
  roles:
    - marcuwynu23.node_app_server_bootstrap.pm2
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.nginx
```

### Install Only Node.js and PM2 (No Nginx)

```yaml
---
- name: Install Node.js with PM2
  hosts: webservers
  become: true
  vars:
    node_state: present
    pm2_state: present
  roles:
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.pm2
```

### Using with Your Application Deployment

```yaml
---
- name: Deploy Node.js Application
  hosts: webservers
  become: true
  vars:
    nginx_state: present
    node_state: present
    pm2_state: present
    app_name: my-app
    app_repo: https://github.com/yourusername/your-app.git
    app_path: /var/www/my-app

  roles:
    - marcuwynu23.node_app_server_bootstrap.nginx
    - marcuwynu23.node_app_server_bootstrap.nodejs
    - marcuwynu23.node_app_server_bootstrap.pm2

  tasks:
    - name: Clone application repository
      git:
        repo: "{{ app_repo }}"
        dest: "{{ app_path }}"
        version: main

    - name: Install npm dependencies
      npm:
        path: "{{ app_path }}"
        state: present

    - name: Start application with PM2
      command: pm2 start npm --name "{{ app_name }}" -- start
      args:
        chdir: "{{ app_path }}"
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

### Test Files

| File | Description |
|------|-------------|
| `tests/test-install.yml` | Validates installation workflow |
| `tests/test-uninstall.yml` | Validates uninstallation workflow |
| `tests/inventory.ini.test` | Test inventory for local testing |

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

**NodeSource Repository Issues:**
```
FAILED! => "msg": "Failed to update apt cache"
```
**Solution:** Ensure the target system has internet access and can reach `deb.nodesource.com`.

---

**PM2 Installation Fails:**
```
FAILED! => "msg": "npm: command not found"
```
**Solution:** Ensure the `nodejs` role is applied before `pm2`.

### Debug Mode

Run playbooks with verbose output for debugging:

```bash
ansible-playbook -i inventory.ini setup.yml -vvv
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Mark Wayne** - [marcuwynu23](https://galaxy.ansible.com/marcuwynu23)

---

## Support

If you find this collection helpful, please consider giving it a star on [GitHub](https://github.com/marcuwynu23/ansible-collections) and rating it on [Ansible Galaxy](https://galaxy.ansible.com/marcuwynu23/node_app_server_bootstrap).

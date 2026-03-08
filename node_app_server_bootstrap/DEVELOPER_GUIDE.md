# Developer Guide

This guide covers how to develop, test, build, and publish the `marcuwynu23.node_app_server_bootstrap` Ansible collection.

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
cd ansible-collections/node_app_server_bootstrap

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
node_app_server_bootstrap/
├── galaxy.yml                 # Collection metadata
├── README.md                  # User documentation
├── DEVELOPER_GUIDE.md         # This file
├── playbooks/
│   ├── install.yml            # Installation playbook
│   ├── uninstall.yml          # Uninstallation playbook
│   └── inventory.ini.example  # Example inventory
├── roles/
│   ├── nginx/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   ├── nodejs/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── test.yml
│   │   │   └── inventory.ini.test
│   │   └── README.md
│   └── pm2/
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

### Key Files

| File | Purpose |
|------|---------|
| `galaxy.yml` | Collection metadata (namespace, name, version, dependencies) |
| `roles/*/tasks/main.yml` | Main task files for each role |
| `roles/*/meta/main.yml` | Role metadata and dependencies |
| `roles/*/handlers/main.yml` | Event handlers (e.g., restart services) |
| `tests/*.yml` | Integration test playbooks |

---

## Creating Roles

### Generate a New Role

Use `ansible-galaxy` to scaffold a new role:

```bash
cd roles
ansible-galaxy role init <role_name>
```

This creates the standard role directory structure:

```
<role_name>/
├── defaults/
│   └── main.yml       # Default variables (lowest precedence)
├── files/             # Static files to copy
├── handlers/
│   └── main.yml       # Handlers
├── meta/
│   └── main.yml       # Role metadata and dependencies
├── tasks/
│   └── main.yml       # Main tasks
├── templates/         # Jinja2 templates
├── tests/
│   ├── inventory
│   └── test.yml
├── vars/
│   └── main.yml       # Role variables (higher precedence)
└── README.md
```

### Role Metadata

Update `meta/main.yml` with role information:

```yaml
---
galaxy_info:
  author: Mark Wayne
  description: Description of your role
  license: MIT
  min_ansible_version: "2.9"
  platforms:
    - name: Ubuntu
      versions:
        - focal
        - jammy
    - name: Debian
      versions:
        - buster
        - bullseye

dependencies: []
  # - role: marcuwynu23.node_app_server_bootstrap.nodejs
```

---

## Writing Tasks

### Task Structure

Follow this pattern for state-based tasks (install/uninstall):

```yaml
---
- name: Set desired state
  set_fact:
    my_desired_state: "{{ my_state | default('present') }}"

# Installation tasks
- name: Install package
  apt:
    name: my-package
    state: present
  become: true
  when: my_desired_state == "present"

# Uninstallation tasks
- name: Remove package
  apt:
    name: my-package
    state: absent
    purge: yes
  become: true
  when: my_desired_state == "absent"
```

### Using Handlers

Define handlers in `handlers/main.yml`:

```yaml
---
- name: Restart nginx
  service:
    name: nginx
    state: restarted
  become: true
```

Trigger handlers in tasks:

```yaml
- name: Update nginx configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx
```

### Task Best Practices

1. **Always use `name`**: Every task should have a descriptive name
2. **Use `become: true`**: For tasks requiring elevated privileges
3. **Use `when` conditions**: For conditional execution
4. **Be idempotent**: Tasks should be safe to run multiple times
5. **Use modules over shell**: Prefer Ansible modules over raw shell commands

```yaml
# Good - using module
- name: Install nginx
  apt:
    name: nginx
    state: present

# Avoid - using shell
- name: Install nginx
  shell: apt-get install -y nginx
```

---

## Testing

### Running Role Tests

Each role has its own test playbook:

```bash
# Test nginx role
ansible-playbook -i roles/nginx/tests/inventory.ini.test roles/nginx/tests/test.yml

# Test nodejs role
ansible-playbook -i roles/nodejs/tests/inventory.ini.test roles/nodejs/tests/test.yml

# Test pm2 role
ansible-playbook -i roles/pm2/tests/inventory.ini.test roles/pm2/tests/test.yml
```

### Running Integration Tests

```bash
# Test full installation
ansible-playbook -i tests/inventory.ini.test tests/test-install.yml --ask-become-pass

# Test full uninstallation
ansible-playbook -i tests/inventory.ini.test tests/test-uninstall.yml --ask-become-pass
```

### Linting

Run ansible-lint to check for issues:

```bash
# Lint entire collection
ansible-lint

# Lint specific playbook
ansible-lint playbooks/install.yml

# Lint specific role
ansible-lint roles/nginx/
```

### YAML Validation

```bash
yamllint .
```

### Check Mode (Dry Run)

Test playbooks without making changes:

```bash
ansible-playbook -i inventory.ini setup.yml --check --diff
```

---

## Building the Collection

### Update Version

Before building, update the version in `galaxy.yml`:

```yaml
namespace: marcuwynu23
name: node_app_server_bootstrap
version: 1.0.1  # Increment this
```

### Build the Tarball

```bash
# Navigate to the collection directory
cd node_app_server_bootstrap

# Build the collection
ansible-galaxy collection build

# Output: marcuwynu23-node_app_server_bootstrap-1.0.1.tar.gz
```

### Verify the Build

```bash
# List contents of the tarball
tar -tzf marcuwynu23-node_app_server_bootstrap-1.0.1.tar.gz

# Test local installation
ansible-galaxy collection install marcuwynu23-node_app_server_bootstrap-1.0.1.tar.gz -p ./test_install
```

---

## Publishing to Ansible Galaxy

### Step 1: Create an Ansible Galaxy Account

1. Go to [https://galaxy.ansible.com](https://galaxy.ansible.com)
2. Click **Login** and authenticate with your GitHub account
3. Your Galaxy namespace will be your GitHub username (e.g., `marcuwynu23`)

### Step 2: Get Your API Token

1. Log in to Ansible Galaxy
2. Click your username → **Preferences** → **API Token**
3. Click **Load Token** to reveal your token
4. Copy and save it securely

### Step 3: Configure Authentication

**Option A: Environment Variable (Recommended)**

```bash
export ANSIBLE_GALAXY_TOKEN=your_api_token_here
```

**Option B: Command Line**

```bash
ansible-galaxy collection publish --api-key your_api_token_here ...
```

**Option C: ansible.cfg**

Create or update `~/.ansible.cfg`:

```ini
[galaxy]
server_list = release_galaxy

[galaxy_server.release_galaxy]
url = https://galaxy.ansible.com/
token = your_api_token_here
```

### Step 4: Publish

```bash
# Build the collection (if not already built)
ansible-galaxy collection build

# Publish to Galaxy
ansible-galaxy collection publish marcuwynu23-node_app_server_bootstrap-1.0.1.tar.gz
```

### Step 5: Verify Publication

1. Go to [https://galaxy.ansible.com/marcuwynu23/node_app_server_bootstrap](https://galaxy.ansible.com/marcuwynu23/node_app_server_bootstrap)
2. Verify the new version appears
3. Test installation:

```bash
ansible-galaxy collection install marcuwynu23.node_app_server_bootstrap --force
```

### Publishing Workflow Summary

```bash
# 1. Update version in galaxy.yml
# 2. Commit changes
git add .
git commit -m "Release v1.0.1"
git tag v1.0.1
git push origin main --tags

# 3. Build
ansible-galaxy collection build

# 4. Publish
export ANSIBLE_GALAXY_TOKEN=your_token
ansible-galaxy collection publish marcuwynu23-node_app_server_bootstrap-1.0.1.tar.gz
```

---

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH
```

| Change Type | Version Bump | Example |
|------------|--------------|---------|
| Breaking changes | MAJOR | 1.0.0 → 2.0.0 |
| New features (backward compatible) | MINOR | 1.0.0 → 1.1.0 |
| Bug fixes (backward compatible) | PATCH | 1.0.0 → 1.0.1 |

### Version Update Checklist

1. Update `version` in `galaxy.yml`
2. Update changelog/release notes (if applicable)
3. Commit with message: `Release v1.x.x`
4. Create git tag: `git tag v1.x.x`
5. Build and publish

---

## Best Practices

### Code Quality

- **Use ansible-lint**: Run before every commit
- **Follow YAML style**: 2-space indentation, no trailing whitespace
- **Use meaningful names**: Descriptive task and variable names
- **Document variables**: Add comments for complex variables

### Role Design

- **Single responsibility**: Each role should do one thing well
- **Idempotent**: Running twice should produce the same result
- **Configurable**: Use variables with sensible defaults
- **Testable**: Include test playbooks for each role

### Security

- **No hardcoded secrets**: Use Ansible Vault for sensitive data
- **Minimal privileges**: Only use `become: true` when necessary
- **Validate inputs**: Check variable values before using them

### Documentation

- **README for each role**: Explain purpose, variables, and examples
- **Inline comments**: For complex logic only
- **Update docs**: Keep README and DEVELOPER_GUIDE current

### Git Workflow

```bash
# Feature branch workflow
git checkout -b feature/new-role
# ... make changes ...
git add .
git commit -m "Add new role for X"
git push origin feature/new-role
# Create Pull Request

# Release workflow
git checkout main
git pull origin main
# Update version in galaxy.yml
git add galaxy.yml
git commit -m "Release v1.x.x"
git tag v1.x.x
git push origin main --tags
```

---

## Troubleshooting Development Issues

### ansible-lint Errors

```bash
# See detailed error messages
ansible-lint -v

# Skip specific rules
ansible-lint --skip-list yaml[line-length]
```

### Build Failures

```
ERROR! galaxy.yml not found
```
**Solution:** Ensure you're in the collection root directory.

---

```
ERROR! Invalid version format
```
**Solution:** Use semantic versioning (e.g., `1.0.0`, not `v1.0.0`).

### Publish Failures

```
ERROR! Error when publishing: HTTP 401
```
**Solution:** Verify your API token is correct and not expired.

---

```
ERROR! Collection namespace does not match
```
**Solution:** Ensure `namespace` in `galaxy.yml` matches your Galaxy username.

---

## Resources

- [Ansible Galaxy Documentation](https://galaxy.ansible.com/docs/)
- [Ansible Collection Developer Guide](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html)
- [Semantic Versioning](https://semver.org/)

---

## Author

**Mark Wayne** - [marcuwynu23](https://github.com/marcuwynu23)

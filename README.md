# Ansible Collections

This repository contains Ansible collections for various automation tasks.

## Structure

```
<collection_name>/
├── playbooks/           # Playbooks related to the collection
└── roles/               # Roles included in the collection
```

### Getting Started

1. Clone the repository:

   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. Run a playbook from the desired collection:

   ```bash
   ansible-playbook <collection_name>/playbooks/<playbook_name>.yml -i inventory.ini
   ```

### Requirements

- Ansible 2.9 or higher
- Linux server (Ubuntu/Debian recommended)

### Contributing

Contributions, issues, and feature requests are welcome. Please follow standard GitHub workflow for pull requests.

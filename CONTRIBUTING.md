# Contributing

Contributions are welcome! Please follow the standard GitHub workflow:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

## Guidelines

- Follow existing code style and conventions
- Write clear commit messages
- Update documentation if needed
- Test your changes before submitting

## Reporting Issues

Report issues via [GitHub Issues](https://github.com/marcuwynu23/ansible-collections/issues) with a clear description and steps to reproduce.

## Getting Started

1. Clone the repository:

   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. Run a playbook from the desired collection:

   ```bash
   ansible-playbook <collection_name>/playbooks/<playbook_name>.yml -i inventory.ini
   ```

## Publishing to Ansible Galaxy

1. Navigate to the collection directory you want to publish:

   ```bash
   cd <collection_name>
   ```

2. Build the collection (use `--force` to overwrite existing builds):

   ```bash
   ansible-galaxy collection build
   # Or with force:
   ansible-galaxy collection build --force
   ```

3. Publish the collection (replace `<collection-tarball>` and `<token>` with your actual values):

   ```bash
   ansible-galaxy collection publish <collection-tarball>-1.0.0.tar.gz --server https://galaxy.ansible.com --token <token>
   ```

## Requirements

- Ansible 2.9 or higher
- Linux server (Ubuntu/Debian recommended)

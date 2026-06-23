# Developer Guide

## Structure

```
php_app_server_bootstrap/
├── playbooks/
│   ├── install.yml
│   ├── inventory.ini.example
│   └── uninstall.yml
├── roles/
│   ├── nginx/
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   │   ├── inventory.ini.test
│   │   │   └── test.yml
│   │   └── README.md
│   └── php/
│       ├── meta/
│       │   └── main.yml
│       ├── tasks/
│       │   └── main.yml
│       ├── tests/
│       │   ├── inventory.ini.test
│       │   └── test.yml
│       └── README.md
└── tests/
    ├── inventory.ini.test
    ├── test-install.yml
    └── test-uninstall.yml
```

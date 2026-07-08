# Docker Role

Installs Docker Engine from official Docker repositories.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `docker_state` | `present` | Set to `present` to install, `absent` to uninstall |
| `docker_compose_state` | `present` | Set to `present` to install Docker Compose v2 plugin |

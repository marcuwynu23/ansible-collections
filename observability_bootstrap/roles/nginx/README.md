# Nginx Role

Installs and configures Nginx for the observability stack, with configurable API server endpoints.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `nginx_state` | `present` | Set to `present` to install, `absent` to uninstall |
| `observability_api_servers` | `[]` | List of API server configurations to proxy |

## Example API Server Configuration

```yaml
observability_api_servers:
  - server_name: prometheus.example.com
    listen_port: 80
    proxy_pass: http://localhost:9090
  - server_name: grafana.example.com
    listen_port: 80
    proxy_pass: http://localhost:3000
  - server_name: loki.example.com
    listen_port: 80
    proxy_pass: http://localhost:3100
  - server_name: tempo.example.com
    listen_port: 80
    proxy_pass: http://localhost:3200
```
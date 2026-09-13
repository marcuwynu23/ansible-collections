# k3s role

Installs K3s on Fedora via the official `get.k3s.io` script: a `server`
(control-plane) or an `agent` (worker). Writes
`/etc/rancher/k3s/config.yaml` **before** installing (the script starts the
service immediately), then enables `k3s` / `k3s-agent` via systemd.

## Layout on the target

| Path | Purpose |
|------|---------|
| `/etc/rancher/k3s/config.yaml` | Node config (`server:`, `token:`, plus `k3s_config_extra`) |
| `/var/lib/rancher/k3s/server/node-token` | Cluster join token (servers only) |
| `/etc/rancher/k3s/k3s.yaml` | Kubeconfig (servers only) |
| `/usr/local/bin/k3s-uninstall.sh` / `k3s-agent-uninstall.sh` | Uninstall scripts used when `k3s_state: absent` |

The installer also symlinks `kubectl`/`crictl`/`ctr` into `/usr/local/bin`.

## Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `k3s_type` | `server` | `server` or `agent` |
| `k3s_state` | `present` | `present` installs, `absent` uninstalls |
| `k3s_version` | `""` (latest stable) | Pin e.g. `v1.30.2+k3s1` |
| `k3s_channel` | `stable` | `INSTALL_K3S_CHANNEL` for the install script |
| `k3s_install_script_url` | `https://get.k3s.io` | Install script source |
| `k3s_server_url` | `""` | e.g. `https://192.168.1.100:6443` — required for agents and extra servers |
| `k3s_token` | `""` | Cluster token — required for agents and extra servers |
| `k3s_config_extra` | `{}` | Merged into `config.yaml` (e.g. `{tls-san: [k8s.example.com], disable: [traefik]}`) |
| `k3s_config_path` | `/etc/rancher/k3s/config.yaml` | Config file location |
| `k3s_firewall_manage` | `true` | Open K3s firewall ports per node type |

Agents need both `k3s_server_url` and `k3s_token`; the role fails fast with
a clear message when they are missing.

## Example

```yaml
# Control-plane:
- hosts: master
  become: true
  roles:
    - role: roles/k3s
      vars:
        k3s_type: server

# Worker:
- hosts: worker
  become: true
  roles:
    - role: roles/k3s
      vars:
        k3s_type: agent
        k3s_server_url: https://192.168.1.100:6443
        k3s_token: <node-token>
```

## License

MIT. Author: Mark Wayne.

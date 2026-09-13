# rke2 role

Installs RKE2 on Fedora via the official `get.rke2.io` script: a `server`
(control-plane) or an `agent` (worker). Writes
`/etc/rancher/rke2/config.yaml`, then enables `rke2-server` / `rke2-agent`
via systemd.

## Layout on the target

| Path | Purpose |
|------|---------|
| `/etc/rancher/rke2/config.yaml` | Node config (`server:`, `token:`, plus `rke2_config_extra`) |
| `/var/lib/rancher/rke2/server/node-token` | Cluster join token (servers only) |
| `/etc/rancher/rke2/rke2.yaml` | Kubeconfig (servers only) |
| `/usr/local/bin/rke2-uninstall.sh` | Uninstall script used when `rke2_state: absent` |

## Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `rke2_type` | `server` | `server` or `agent` |
| `rke2_state` | `present` | `present` installs, `absent` uninstalls |
| `rke2_version` | `""` (latest stable) | Pin e.g. `v1.30.2+rke2r1` |
| `rke2_channel` | `stable` | `INSTALL_RKE2_CHANNEL` for the install script |
| `rke2_install_script_url` | `https://get.rke2.io` | Install script source |
| `rke2_server_url` | `""` | e.g. `https://192.168.1.100:9345` — required for agents and extra servers |
| `rke2_token` | `""` | Cluster token — required for agents and extra servers |
| `rke2_config_extra` | `{}` | Merged into `config.yaml` (e.g. `{tls-san: [k8s.example.com], cni: [canal]}`) |
| `rke2_config_path` | `/etc/rancher/rke2/config.yaml` | Config file location |
| `rke2_firewall_manage` | `true` | Open RKE2 firewall ports per node type |
| `rke2_kubectl_link` | `true` | Symlink `kubectl`/`crictl`/`ctr` into `/usr/local/bin` |

Agents need both `rke2_server_url` and `rke2_token`; the role fails fast with
a clear message when they are missing.

## Example

```yaml
# Control-plane:
- hosts: master
  become: true
  roles:
    - role: roles/rke2
      vars:
        rke2_type: server

# Worker:
- hosts: worker
  become: true
  roles:
    - role: roles/rke2
      vars:
        rke2_type: agent
        rke2_server_url: https://192.168.1.100:9345
        rke2_token: <node-token>
```

## License

MIT. Author: Mark Wayne.

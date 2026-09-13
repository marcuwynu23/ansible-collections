# Ansible Collection - marcuwynu23.fedora_k8s_k3s_bootstrap

Bootstrap a Kubernetes cluster with [K3s](https://k3s.io/) on Fedora virtual
machines: OS preparation, optional standalone containerd, and K3s
server (control-plane) / agent (worker) installation.

## Contents

| Path | Purpose |
|------|---------|
| `roles/pre` | Fedora node prep: dnf upgrade, base packages, swap off, kernel modules, sysctl, SELinux, firewalld, NetworkManager |
| `roles/containerd` | Optional standalone containerd (K3s embeds its own; disabled by default in the playbooks) |
| `roles/k3s` | K3s server/agent install via `get.k3s.io`, `/etc/rancher/k3s/config.yaml`, systemd service |
| `playbooks/install-master.yml` | Install the first (or an additional) control-plane node (`hosts: master`) |
| `playbooks/install-worker.yml` | Join worker nodes (`hosts: worker`, requires server URL + node-token) |
| `playbooks/uninstall-master.yml` / `uninstall-worker.yml` | Remove K3s (runs `k3s-uninstall.sh` / `k3s-agent-uninstall.sh`) |
| `playbooks/inventory.ini.example` | Key-only SSH inventory template (no passwords, no prompts) |

## Requirements

- Ansible 2.9+ on the controller.
- Fedora targets with Python 3 and SSH key access. Copy
  `playbooks/inventory.ini.example` to `inventory.ini`, set your hosts and
  `ansible_ssh_private_key_file`. The key must already be trusted by the
  targets (public key in the remote user's `authorized_keys`).

## Quick start

```bash
cp playbooks/inventory.ini.example inventory.ini   # adjust hosts/key
ansible-playbook -i inventory.ini playbooks/install-master.yml
# join token for workers:
sudo cat /var/lib/rancher/k3s/server/node-token
ansible-playbook -i inventory.ini playbooks/install-worker.yml \
  -e k3s_server_url=https://192.168.1.100:6443 \
  -e k3s_token=<node-token>
```

Kubeconfig on servers: `/etc/rancher/k3s/k3s.yaml`.

## Key variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `k3s_type` | `server` | `server` for control-plane, `agent` for workers |
| `k3s_state` | `present` | `present` installs, `absent` uninstalls |
| `k3s_version` | `""` (latest stable) | Pin e.g. `v1.30.2+k3s1` |
| `k3s_channel` | `stable` | Release channel for the install script |
| `k3s_server_url` | `""` | Join URL, e.g. `https://192.168.1.100:6443` (agents + extra servers) |
| `k3s_token` | `""` | Cluster token from the first server's node-token |
| `k3s_config_extra` | `{}` | Extra keys merged into `/etc/rancher/k3s/config.yaml` (e.g. `{tls-san: [k8s.example.com], disable: [traefik]}`) |
| `containerd_enabled` | `false` (in playbooks) | Set `true` only if you also want system containerd next to K3s |

Additional servers joining a cluster set `k3s_server_url`, `k3s_token` and
typically `k3s_config_extra: {cluster-init: true}` (embedded etcd HA).

## License

MIT. Author: Mark Wayne.

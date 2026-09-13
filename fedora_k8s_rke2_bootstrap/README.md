# Ansible Collection - marcuwynu23.fedora_k8s_rke2_bootstrap

Bootstrap a Kubernetes cluster with [RKE2](https://docs.rke2.io/) on Fedora
virtual machines: OS preparation, optional standalone containerd, and RKE2
server (control-plane) / agent (worker) installation.

## Contents

| Path | Purpose |
|------|---------|
| `roles/pre` | Fedora node prep: dnf upgrade, base packages, swap off, kernel modules, sysctl, SELinux, firewalld, NetworkManager |
| `roles/containerd` | Optional standalone containerd (RKE2 embeds its own; disabled by default in the playbooks) |
| `roles/rke2` | RKE2 server/agent install via `get.rke2.io`, `/etc/rancher/rke2/config.yaml`, systemd service |
| `playbooks/install-master.yml` | Install the first (or an additional) control-plane node (`hosts: master`) |
| `playbooks/install-worker.yml` | Join worker nodes (`hosts: worker`, requires server URL + node-token) |
| `playbooks/uninstall-master.yml` / `uninstall-worker.yml` | Remove RKE2 (runs `rke2-uninstall.sh`) |
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
sudo cat /var/lib/rancher/rke2/server/node-token
ansible-playbook -i inventory.ini playbooks/install-worker.yml \
  -e rke2_server_url=https://192.168.1.100:9345 \
  -e rke2_token=<node-token>
```

Kubeconfig on servers: `/etc/rancher/rke2/rke2.yaml`.

## Key variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `rke2_type` | `server` | `server` for control-plane, `agent` for workers |
| `rke2_state` | `present` | `present` installs, `absent` uninstalls |
| `rke2_version` | `""` (latest stable) | Pin e.g. `v1.30.2+rke2r1` |
| `rke2_channel` | `stable` | Release channel for the install script |
| `rke2_server_url` | `""` | Join URL, e.g. `https://192.168.1.100:9345` (agents + extra servers) |
| `rke2_token` | `""` | Cluster token from the first server's node-token |
| `rke2_config_extra` | `{}` | Extra keys merged into `/etc/rancher/rke2/config.yaml` (e.g. `{tls-san: [k8s.example.com], cni: [canal]}`) |
| `containerd_enabled` | `false` (in playbooks) | Set `true` only if you also want system containerd next to RKE2 |

## License

MIT. Author: Mark Wayne.

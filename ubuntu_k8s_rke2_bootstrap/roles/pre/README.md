# pre role

Ubuntu OS preparation for RKE2 Kubernetes nodes. Replaces manual setup:
hostname, system updates, swap, kernel modules, sysctl and firewall.
Uses `apt`/`ufw` (no `dnf`/`firewalld`). Ubuntu runs AppArmor (RKE2 works
with its defaults), so there are no SELinux tasks.

## What it does

- Asserts the target is Ubuntu / Debian family.
- Optionally sets the hostname (`pre_hostname`).
- Optionally upgrades all packages (`apt upgrade`).
- Installs base packages (curl, iptables, socat, conntrack, ufw, ...).
- Disables swap at runtime and removes it from `/etc/fstab` (required by Kubernetes).
- Persists/loads `overlay` + `br_netfilter` kernel modules.
- Applies sysctl (`ip_forward`, bridge-nf-call) via `/etc/sysctl.d/99-k8s-rke2.conf`.
- Allows SSH, opens RKE2 firewall ports (6443 API, 9345 supervisor, 10250
  kubelet, flannel/wireguard, NodePorts, etcd) and enables `ufw`.

## Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `pre_hostname` | `""` (skip) | Hostname to set |
| `pre_update_system` | `true` | Run `apt upgrade` |
| `pre_disable_swap` | `true` | Disable swap now and in fstab |
| `pre_firewall_manage` | `true` | Manage ufw + RKE2 ports |
| `pre_firewall_allow_ssh_port` | `22/tcp` | Allowed before ufw is enabled (empty skips) |
| `pre_base_packages` | (list) | Packages installed via apt |
| `pre_kernel_modules` | `[overlay, br_netfilter]` | Modules to persist and load |
| `pre_sysctl_params` | (dict) | Sysctl keys written to `99-k8s-rke2.conf` |
| `pre_firewall_ports` | (list) | Ports opened when `pre_firewall_manage` is true (ufw range syntax, e.g. `30000:32767/tcp`) |

## Example

```yaml
- hosts: master
  become: true
  roles:
    - role: roles/pre
      vars:
        pre_hostname: k8s-master-1
```

## License

MIT. Author: Mark Wayne.

# containerd role

Installs and configures standalone containerd on Fedora (`dnf`,
`/etc/containerd/config.toml` with `SystemdCgroup = true`, systemd service).

> **Note:** RKE2 ships and manages its own embedded containerd, so the
> collection playbooks set `containerd_enabled: false` by default. Enable
> this role only if you also want a system-wide containerd next to RKE2.

## Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `containerd_state` | `present` | `present` installs, `absent` removes |
| `containerd_enabled` | `true` | `false` skips everything (used by the RKE2 playbooks) |
| `containerd_config_path` | `/etc/containerd/config.toml` | Config file (generated once via `containerd config default`) |
| `containerd_systemd_cgroup` | `true` | Enforce `SystemdCgroup = true` in the config |

## Example

```yaml
- hosts: master
  become: true
  roles:
    - role: roles/containerd
      vars:
        containerd_state: present
```

## License

MIT. Author: Mark Wayne.

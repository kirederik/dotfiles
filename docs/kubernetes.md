# Kubernetes

## Aliases

```sh
k   → kubectl              (with full tab completion)
kx  → kubectx              (context switching)
kn  → kubens               (namespace switching)
kp  → kubectl --context kind-platform
kw  → kubectl --context kind-work
```

---

## Tools

| Tool | Source | Purpose |
|---|---|---|
| `kubectl` | Homebrew | CLI |
| `kubectx` / `kubens` | Homebrew | Context and namespace switching |
| `k9s` | Homebrew | TUI cluster browser |
| `stern` | Homebrew | Multi-pod log tailing |
| `kubeseal` | Homebrew | Sealed Secrets CLI |
| krew plugins | `kube-tools.sh` | See below |

---

## krew plugins

Install/update: `./kube-tools.sh` (idempotent).

| Plugin | Purpose |
|---|---|
| `neat` | Strip managed fields from YAML — essential for reading CRDs |
| `tree` | Show resource ownership hierarchy |
| `images` | List all container images in the cluster |
| `resource-capacity` | Node/pod resource requests and limits |
| `df-pv` | Disk usage of PersistentVolumes |
| `who-can` | Which subjects can perform a given RBAC action |
| `access-matrix` | Full RBAC matrix for a namespace |
| `view-secret` | Decode secret values inline |
| `get-all` | Every resource in a namespace, including CRDs |

---

## MinIO (local kind cluster)

If port 31337 is open on localhost, `mc` is auto-configured with a `kind` alias pointing to the local MinIO instance (`http://localhost:31337`, credentials `minioadmin/minioadmin`).

---

## Prompt context indicator

The current context is shown on the right of the starship prompt as `☸ <context> (<namespace>)`, configured in `dot_config/starship.toml`. Two things are needed, since starship ships the module disabled *and* the `format` string is explicit: `[kubernetes] disabled = false` **and** `$kubernetes` in `format`.

Colour encodes risk:

| Context | Colour |
|---|---|
| `kind-*` (local throwaway) | green |
| EKS ARNs | red |
| anything else | cyan (default) |

EKS contexts are rewritten from the full ARN to `eks/<cluster>` via `context_alias`. That keeps the prompt readable and keeps the **AWS account ID out of screenshots and screen shares**, since it's embedded in the ARN.

It's shown unconditionally rather than gated behind `detect_files`/`detect_folders`, so the target cluster is visible before any `kubectl` runs — not just inside k8s project directories. Add `detect_folders` if that's too noisy.

Starship re-reads its config on every prompt render, so changes here need no shell restart.

---

## Notes

- `~/.kube/config` is **not** managed by chezmoi — it's machine-specific. Regenerate with the cloud provider CLI (`gcloud container clusters get-credentials`, `aws eks update-kubeconfig`, etc.)
- k9s locks Zellij automatically (TUI autolock wrapper in `.zshrc`)

#!/usr/bin/env bash
# Install kubectl plugins via krew.
# Run manually or via bootstrap.sh.
# Tools available in Homebrew (kubectl, kubectx, k9s, stern) are in the Brewfile instead.
set -euo pipefail

echo "==> Installing kubectl plugins via krew..."

# Ensure krew itself is up to date
kubectl krew update

plugins=(
  # ─── Output / readability ─────────────────────────────────────────────────
  neat             # strip managed fields from YAML output — essential for reading CRDs
  tree             # show ownership hierarchy of resources (great for operators/Kratix)

  # ─── Workload inspection ──────────────────────────────────────────────────
  images           # list all container images running in the cluster
  resource-capacity # show node/pod resource requests and limits at a glance
  df-pv            # disk usage of PersistentVolumes

  # ─── RBAC ─────────────────────────────────────────────────────────────────
  who-can          # show which subjects can perform a given action
  access-matrix    # full RBAC access matrix for a namespace

  # ─── Secrets ──────────────────────────────────────────────────────────────
  view-secret      # base64-decode secret values inline (no manual piping)

  # ─── Bulk operations ──────────────────────────────────────────────────────
  get-all          # get every resource in a namespace (including CRDs)
)

for plugin in "${plugins[@]}"; do
  # Skip comment lines
  [[ "$plugin" == \#* ]] && continue
  [[ -z "$plugin" ]] && continue

  if kubectl krew list | grep -q "^${plugin}$"; then
    echo "  already installed: $plugin"
  else
    echo "  installing: $plugin"
    kubectl krew install "$plugin"
  fi
done

echo "==> kubectl plugins installed."

#!/usr/bin/env bash
# Install Python CLI tools via pipx.
# Each tool gets its own isolated virtualenv — no conflicts, clean uninstalls.
# Run manually or via bootstrap.sh.
set -euo pipefail

echo "==> Installing Python tools via pipx..."

pipx ensurepath

tools=(
  gita          # run git commands across multiple repos
)

for tool in "${tools[@]}"; do
  if pipx list | grep -q "package ${tool}"; then
    echo "  already installed: $tool"
  else
    echo "  installing: $tool"
    pipx install "$tool"
  fi
done

echo "==> Python tools installed."

#!/usr/bin/env bash
# Install global bun packages not available in Homebrew.
# Run manually: bash bun-tools.sh
set -euo pipefail

echo "==> Installing bun tools..."

# ─── Git hooks ────────────────────────────────────────────────────────────────
bun install -g @commitlint/cli @commitlint/config-conventional

echo "==> Bun tools installed."

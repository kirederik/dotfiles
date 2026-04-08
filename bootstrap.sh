#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Sudo — ask once, keep alive for the whole script ─────────────────────────
echo "==> Requesting sudo (needed for Homebrew install and macOS defaults)..."
sudo -v
# Refresh the sudo token every 60s in the background until this script exits
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

# ─── Xcode Command Line Tools ─────────────────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  echo "==> Xcode Command Line Tools not found."
  echo "    Run: xcode-select --install"
  echo "    Wait for installation to complete, then re-run this script."
  exit 1
fi

# ─── Homebrew ─────────────────────────────────────────────────────────────────
echo "==> Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ─── Packages ─────────────────────────────────────────────────────────────────
echo "==> Installing packages from Brewfile..."
export HOMEBREW_CASK_OPTS="--no-quarantine"
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ─── Dotfiles ─────────────────────────────────────────────────────────────────
echo "==> Applying dotfiles with chezmoi..."
chezmoi init --source "$DOTFILES_DIR" --apply

# ─── Runtimes ─────────────────────────────────────────────────────────────────
echo "==> Installing runtimes via mise..."
mise install

# Make mise-managed tools available for the rest of this script
export PATH="$HOME/.local/share/mise/shims:$PATH"

# ─── Go tools ─────────────────────────────────────────────────────────────────
echo "==> Installing Go tools..."
bash "$DOTFILES_DIR/go-tools.sh"

# ─── Python tools ────────────────────────────────────────────────────────────
echo "==> Installing Python tools..."
bash "$DOTFILES_DIR/python-tools.sh"

# ─── Commitlint ───────────────────────────────────────────────────────────────
echo "==> Installing commitlint..."
bun install -g @commitlint/cli @commitlint/config-conventional

# ─── kubectl plugins ──────────────────────────────────────────────────────────
echo "==> Installing kubectl plugins..."
bash "$DOTFILES_DIR/kube-tools.sh"

# ─── Dev directory ────────────────────────────────────────────────────────────
echo "==> Creating ~/dev..."
mkdir -p "$HOME/dev"

# ─── SSH sockets dir ──────────────────────────────────────────────────────────
mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh/sockets"

# ─── bat: Catppuccin theme ────────────────────────────────────────────────────
echo "==> Installing bat Catppuccin theme..."
BAT_THEMES="$(bat --config-dir)/themes"
mkdir -p "$BAT_THEMES"
if [[ ! -f "$BAT_THEMES/Catppuccin Mocha.tmTheme" ]]; then
  curl -sLo "$BAT_THEMES/Catppuccin Mocha.tmTheme" \
    https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build
fi

# ─── Neovim / LazyVim ─────────────────────────────────────────────────────────
if [[ ! -f "$HOME/.config/nvim/init.lua" ]]; then
  echo "==> Bootstrapping LazyVim..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
fi

# ─── macOS defaults ───────────────────────────────────────────────────────────
echo "==> Applying macOS defaults..."
bash "$DOTFILES_DIR/macos.sh"

# ─── Karabiner-Elements ───────────────────────────────────────────────────────
# Open the app so it can prompt for system extension approval immediately.
# Without this it silently does nothing until manually opened.
echo "==> Opening Karabiner-Elements (approve the system extension when prompted)..."
open -a "Karabiner-Elements" 2>/dev/null || true

# ─── Rectangle ────────────────────────────────────────────────────────────────
echo "==> Starting Rectangle..."
defaults write com.knollsoft.Rectangle launchOnLogin -bool true
open -a "Rectangle" 2>/dev/null || true

# ─── Maccy ────────────────────────────────────────────────────────────────────
echo "==> Starting Maccy..."
defaults write org.p0deje.Maccy launchOnLogin -bool true
open -a "Maccy" 2>/dev/null || true

# ─── Atuin daemon ─────────────────────────────────────────────────────────────
echo "==> Starting Atuin daemon..."
launchctl bootstrap gui/"$(id -u)" \
  "$HOME/Library/LaunchAgents/sh.atuin.atuin.plist" 2>/dev/null || true

echo ""
echo "==> Done! Open a new terminal to get started."
echo ""
echo "    Manual steps required:"
echo "    1. Karabiner: approve the system extension in System Settings → Privacy & Security"
echo "    2. Bitwarden: Settings → SSH Agent → enable"
echo "    3. GPG key: gpg --import <exported-key.asc>"
echo "    4. Accessibility: grant Rectangle, Zoom, etc. when prompted on first open"

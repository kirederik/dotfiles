#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Xcode Command Line Tools ─────────────────────────────────────────────────
# Must be installed before anything else. If not present, print instructions
# and exit — the GUI installer dialog can't be automated in a script.
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
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ─── Dotfiles ─────────────────────────────────────────────────────────────────
echo "==> Applying dotfiles with chezmoi..."
chezmoi init --source "$DOTFILES_DIR" --apply

# ─── Runtimes ─────────────────────────────────────────────────────────────────
echo "==> Installing runtimes via mise..."
mise install

# ─── Go tools ─────────────────────────────────────────────────────────────────
echo "==> Installing Go tools..."
bash "$DOTFILES_DIR/go-tools.sh"

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

echo ""
echo "==> Done! Open a new terminal to get started."
echo "    Neovim will finish installing plugins on first launch (nvim)."
echo "    Remember to: enable Bitwarden SSH agent in Bitwarden → Settings → SSH Agent"
echo "    Remember to: import your GPG key (gpg --import <key>)"

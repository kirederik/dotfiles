# dotfiles

Personal macOS setup for [@kirederik](https://github.com/kirederik). Managed with [chezmoi](https://chezmoi.io).

## Fresh machine setup

```sh
xcode-select --install
# Wait for the installer dialog to complete, then:

git clone git@github.com:kirederik/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./bootstrap.sh
```

`bootstrap.sh` installs Homebrew, all packages from `Brewfile`, applies dotfiles via chezmoi, installs runtimes via mise, sets up Neovim/LazyVim, and applies macOS system defaults.

### After bootstrap

| Step | Action |
|---|---|
| GPG key | `gpg --import <exported-key.asc>` |
| Bitwarden SSH agent | Bitwarden → Settings → SSH Agent → enable |
| Syncthing | `brew services start syncthing` → configure at `http://localhost:8384` |
| Raycast | Set hotkeys: `ctrl+opt+m` maximize, `ctrl+opt+c` center, `cmd+shift+v` clipboard |
| Raycast settings backup | `chezmoi re-add ~/.config/raycast/settings.rayconfig` after setup |
| VS Code / Cursor sync | Sign in to Settings Sync with GitHub |
| Logitech Options+ | Sign in — syncs via Logi account |
| Stream Deck profiles | Add `~/Library/Application Support/com.elgato.StreamDeck/ProfilesV2/` to Syncthing |
| Neovim plugins | Run `nvim` once — LazyVim installs everything automatically |
| Neovim Copilot | `:Copilot auth` inside nvim |
| Ruby | `mise install` (installs Ruby 3 and other runtimes) |

---

## Tools at a glance

| Category | Tools |
|---|---|
| **Shell** | zsh + antidote, starship, atuin, zoxide, direnv |
| **Terminal** | Ghostty + Zellij (tmux kept for SSH/remote) |
| **Editor** | Neovim/LazyVim (daily config), Cursor (AI IDE) |
| **VCS** | jj (primary), git, lazygit, ghq, git-mob |
| **Runtimes** | mise → bun, node LTS, go, ruby 3 |
| **Packages** | Homebrew (Brewfile) |
| **Kubernetes** | kubectl, kubectx/kubens, k9s, stern, krew |
| **Window mgmt** | Raycast (windows + clipboard + launcher) |
| **Secrets** | Bitwarden (passwords + SSH agent) |
| **Sync** | chezmoi (dotfiles), Syncthing (documents/notes) |

---

## What chezmoi manages

| Source | Destination |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_zsh_plugins.txt` | `~/.zsh_plugins.txt` |
| `dot_gitconfig` | `~/.gitconfig` |
| `dot_gitconfig-personal` | `~/.gitconfig-personal` |
| `dot_gitconfig-work` | `~/.gitconfig-work` |
| `dot_gitignore_global` | `~/.gitignore_global` |
| `dot_gitmessage` | `~/.gitmessage` |
| `dot_tool-versions` | `~/.tool-versions` (mise runtimes) |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/starship.toml` | `~/.config/starship.toml` |
| `dot_config/zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| `dot_config/jj/config.toml` | `~/.config/jj/config.toml` |
| `dot_config/atuin/config.toml` | `~/.config/atuin/config.toml` |
| `dot_config/karabiner/karabiner.json` | `~/.config/karabiner/karabiner.json` |
| `dot_config/nvim/` | `~/.config/nvim/` (config only, not plugins) |
| `dot_claude/` | `~/.claude/` (Claude Code config + statusline) |
| `dot_local/bin/executable_*` | `~/.local/bin/*` (personal scripts) |
| `private_dot_ssh/private_config` | `~/.ssh/config` (mode 600) |
| `private_dot_gnupg/gpg-agent.conf` | `~/.gnupg/gpg-agent.conf` (mode 600) |

### Not managed by chezmoi

| Config | Reason |
|---|---|
| Neovim plugins (`~/.local/share/nvim`) | LazyVim self-manages |
| VS Code / Cursor settings | Built-in Settings Sync |
| `~/.kube/config` | Machine-specific |
| Stream Deck profiles | Syncthing |

---

## Updating

```sh
# After editing files in ~/.dotfiles:
chezmoi apply

# Update all packages:
brewup   # alias: brew bundle install + cleanup --force

# Update runtimes:
mise upgrade
```

---

## Detailed docs

- [Shell (zsh, aliases, keybindings)](docs/zsh.md)
- [Zellij](docs/zellij.md)
- [Neovim / LazyVim](docs/neovim.md)
- [jj (Jujutsu)](docs/jj.md)
- [Git (identity, mob, conventional commits)](docs/git.md)
- [Kubernetes](docs/kubernetes.md)
- [tmux](docs/tmux.md)

# ─── Dotfile / environment management ────────────────────────────────────────
brew "chezmoi"        # dotfiles manager
brew "mise"           # runtime version manager (replaces nvm/pyenv/rbenv)

# ─── Shell ────────────────────────────────────────────────────────────────────
brew "zsh"            # Homebrew zsh (not system)
brew "antidote"       # lightweight zsh plugin manager
brew "starship"       # cross-shell prompt
brew "atuin"          # shell history replacement (ctrl+r)
brew "zoxide"         # smart cd replacement
brew "fzf"            # fuzzy finder (used by ctrl+g repo jumper)
brew "direnv"         # per-directory environment variables (.envrc)

# ─── Version control ──────────────────────────────────────────────────────────
brew "git"
brew "jujutsu"        # jj — modern VCS on top of git
brew "git-delta"      # better diffs, git pager
brew "lazygit"        # TUI git client
brew "ghq"            # repo organiser (clones to ~/dev/github.com/org/repo)
brew "git-mob"        # co-author tracking for pair/mob programming
brew "pipx"           # install Python CLI tools in isolated environments

# ─── Kubernetes ───────────────────────────────────────────────────────────────
brew "kubectl"
brew "kubectx"        # kubectx + kubens (context/namespace switcher)
brew "krew"           # kubectl plugin manager
brew "k9s"            # TUI cluster browser
brew "stern"          # multi-pod log tailing
brew "kubeseal"       # sealed secrets CLI

# ─── Go toolchain (via Homebrew, not mise — system-wide linters/release tools) ─
brew "golangci-lint"  # meta-linter
brew "goreleaser"     # release automation (OSS — see note below re: pro)
brew "golang-migrate" # database migrations CLI
# goreleaser-pro: install separately with licence key:
#   brew install goreleaser/tap/goreleaser-pro
#   export GORELEASER_KEY="<key>"  (add to a local .envrc, never commit)

# ─── GitHub CLI ───────────────────────────────────────────────────────────────
brew "gh"

# ─── Terminal multiplexers ────────────────────────────────────────────────────
brew "zellij"         # primary multiplexer (floating panes, layout files)
brew "tmux"           # kept for SSH/remote use

# ─── Editor ───────────────────────────────────────────────────────────────────
brew "neovim"         # LazyVim starter installs on first nvim launch

# ─── Modern CLI replacements ──────────────────────────────────────────────────
brew "bat"            # cat with syntax highlighting
brew "eza"            # ls replacement (maintained fork of exa)
brew "fd"             # find replacement
brew "ripgrep"        # grep replacement
brew "dust"           # du replacement
brew "btop"           # top replacement
brew "sd"             # sed replacement (simpler syntax)
brew "xh"             # curl replacement (friendlier HTTP client)

# ─── Utilities ────────────────────────────────────────────────────────────────
brew "gnupg"          # GPG for commit signing
brew "pinentry-mac"   # macOS pinentry dialog for GPG passphrase
brew "syncthing"      # P2P sync for Documents / notes

# ─── Secrets / SSH ────────────────────────────────────────────────────────────
cask "bitwarden"      # password manager + SSH agent

# ─── Keyboard ─────────────────────────────────────────────────────────────────
cask "karabiner-elements"  # key remapper
brew "goku"                # write Karabiner config in readable EDN, compiles to JSON

# ─── Casks ────────────────────────────────────────────────────────────────────
cask "ghostty"        # primary terminal (fast, native, config-file driven)
cask "cursor"         # AI IDE — daily driver
cask "claude"         # Claude desktop app
cask "chatgpt"        # ChatGPT desktop app
cask "zen-browser"    # Arc replacement (Firefox-based, open source)
cask "arc"            # kept during transition to Zen
cask "rectangle"      # window management
cask "slack"
cask "discord"
cask "zoom"

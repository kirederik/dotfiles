# Dotfiles context for Claude Code

This file summarises all decisions made when designing this dotfiles setup.
Use it to resume work: `claude "Read CONTEXT.md and continue building the dotfiles"`

## Goal
Create a fully portable Mac setup for @kirederik (Derik Evangelista, Syntasso).
New machine setup should require only 3 commands:
1. `xcode-select --install`
2. `git clone git@github.com:kirederik/dotfiles.git ~/derik/dotfiles`
3. `cd ~/derik/dotfiles && ./bootstrap.sh`

## Working directory
`~/derik/dotfiles` — this is where the repo lives and where chezmoi is sourced from.

## Tool choices and rationale

### Package management
- **Homebrew** — primary package manager, everything via Brewfile
- **chezmoi** — dotfiles manager (NOT symlinks). Files prefixed with `dot_` become dotfiles in `~`
- **mise** — runtime version manager, replaces nvm/pyenv/rbenv
- `HOMEBREW_CASK_OPTS="--no-quarantine"` set in bootstrap.sh before `brew bundle` (not in Brewfile — `cask_args` syntax is invalid and errors)

### Shell
- **zsh** (Homebrew, not system)
- **antidote** — lightweight plugin manager, reads `~/.zsh_plugins.txt`
- Plugins: zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
- **starship** — prompt
- **atuin** — shell history (ctrl+r)
- **zoxide** — smart cd
- **direnv** — per-directory env variables via `.envrc`

### Runtime: bun over node
- **bun** is primary runtime (listed first in `.tool-versions`)
- **node lts** kept as fallback for team script compatibility
- Only alias: `npx='bunx'` — do NOT alias `node` to `bun`

### Version control
- **jj** (Jujutsu) — modern VCS on top of git; git-compatible
- **git-delta** — diffs/pager
- **lazygit** — TUI git client
- **ghq** — repo organiser, clones to `~/dev/github.com/org/repo`
- **git-mob** — co-author tracking for pair/mob programming
- commitlint global hook via `core.hooksPath = ~/.config/git/hooks`
  - hook: `dot_config/git/hooks/executable_commit-msg`
  - config: `dot_commitlintrc.json`
  - installed via: `bun install -g @commitlint/cli @commitlint/config-conventional`

### Terminal
- **Ghostty** — primary terminal
- Font: Monaco Nerd Font, size 13
- Theme: `theme = Catppuccin Mocha` (Ghostty built-in, exact name with spaces and title case — do NOT use `catppuccin-mocha`, do NOT download external theme files)
- `window-decoration = true`, `macos-titlebar-style = hidden` — macOS border with traffic lights, no title text

### Editor
- **Neovim** with LazyVim — bootstrapped fresh on first `nvim` launch, NOT managed by chezmoi
- **Cursor** — AI IDE (daily driver)

### Multiplexer
- **Zellij** — primary; uses built-in Tmux mode (Ctrl+Space prefix, one-shot)
- TUI autolock via **shell wrappers** in `.zshrc` (not a plugin) — wraps nvim/vim/lazygit/k9s/btop with `zellij action switch-mode locked/normal`. atuin/fzf are excluded (atuin hooks fire on every keystroke).
- **tmux** — kept in Brewfile for SSH/remote use only; catppuccin theme

### Keybindings
- **Karabiner-Elements** — key remapper; config managed as direct JSON (`dot_config/karabiner/karabiner.json`)
- **Goku** — in Brewfile for future complex rules; currently using direct JSON only
- Key device configs:
  - Apple internal (1452:591): fn→right_option, caps→ctrl
  - Logitech (1133:49948): caps→ctrl, swap cmd/opt
  - Razer macro pad (5426:103): keys mapped to mission control, sticky ctrl, mouse buttons
  - Generic/Unknown: caps→ctrl, swap cmd/opt
- System-wide ctrl+w → deleteWordBackward: via `Library/KeyBindings/DefaultKeyBinding.dict`

### Kubernetes
- kubectl, kubectx, krew, k9s, stern, kubeseal
- krew plugins (installed via `kube-tools.sh`): neat, tree, images, resource-capacity, df-pv, who-can, access-matrix, view-secret, get-all

### Git identities (auto-switched by directory)
- Personal: kirederik / kirederik@gmail.com → `~/dev/github.com/kirederik/`
- Work: Derik Evangelista / derik@syntasso.io → `~/dev/github.com/syntasso/`

### SSH / Secrets
- **Bitwarden** — password manager + SSH agent
- `SSH_AUTH_SOCK` set conditionally only if socket exists (degrades gracefully without Bitwarden)
- `private_dot_ssh/private_config` — IdentityAgent for Bitwarden, ControlMaster with 10min persist
- `private_dot_gnupg/gpg-agent.conf` — 8h cache, pinentry-mac

### Sync
- **chezmoi** — dotfiles/config (git-backed)
- **Syncthing** — Documents, notes, non-code files (P2P continuous sync)

### Browsers
- **Zen** — primary (Arc replacement, Firefox-based, open source)
- Arc kept during transition; Dia also installed

### Clipboard / Window management
- **Raycast** — replaces Rectangle (window management) + Maccy (clipboard) + HiddenBar

### AI tools
- Claude Code, Cursor, Claude desktop, ChatGPT desktop

## Install scripts (all in .chezmoiignore, all called from bootstrap.sh)

| Script | Purpose |
|---|---|
| `bootstrap.sh` | Entry point: xcode check, brew bundle, chezmoi apply, mise install, tool scripts, macOS defaults |
| `go-tools.sh` | Go tools not in Homebrew: gofumpt, goimports, golines, staticcheck, govulncheck, gotestsum, ginkgo, richgo, gow, mockgen, wire, cobra-cli, go-enum, gomodifytags, impl, gotests, mage, jsonnet, gojsontoyaml |
| `kube-tools.sh` | krew plugins (idempotent) |
| `python-tools.sh` | pipx tools: gita |
| `macos.sh` | macOS defaults: Finder, Dock, keyboard, screenshots, disable smart quotes |

## bootstrap.sh key details
- Checks `xcode-select -p` first — exits with instructions if CLT not installed (do NOT call `xcode-select --install` in script, it hangs)
- `sudo -v` at top + background keepalive loop — asks for sudo only once
- `export HOMEBREW_CASK_OPTS="--no-quarantine"` before `brew bundle`
- `export PATH="$HOME/.local/share/mise/shims:$PATH"` after `mise install` — needed so bun is available for commitlint install
- Opens Karabiner-Elements, Rectangle, Maccy via `open -a`
- Loads atuin LaunchAgent via `launchctl bootstrap`
- Downloads bat Catppuccin theme to `$(bat --config-dir)/themes/`
- Bootstraps LazyVim only if `~/.config/nvim/init.lua` doesn't exist

## chezmoi file prefix reference
- `dot_` → `.` (e.g. `dot_zshrc` → `~/.zshrc`)
- `private_` → mode 600/700
- `executable_` → mode 755
- No prefix needed for files already under `dot_config/`

## Things NOT to do
- Do NOT use oh-my-zsh
- Do NOT symlink dotfiles — chezmoi handles placement
- Do NOT alias `node` to `bun`
- Do NOT use p10k — use starship
- Do NOT use nvm/pyenv/rbenv — use mise
- Do NOT use exa (unmaintained) — use eza
- Do NOT use `cask_args` in Brewfile — use `HOMEBREW_CASK_OPTS` env var in bootstrap.sh
- Do NOT download external Ghostty theme files — use built-in `theme = Catppuccin Mocha` (exact capitalisation)
- Do NOT manage nvim config with chezmoi for plugins — LazyVim bootstraps itself. Config files (lua/config/, lua/plugins/) ARE managed by chezmoi via dot_config/nvim/
- `macos-option-as-alt = left` in Ghostty (not `true`) — left Option = Alt, right Option = macOS composition
- UK keyboard: `keybind = alt+3=text:#` in Ghostty config compensates for alt+3 not producing #
- Do NOT manage nvim config with chezmoi — LazyVim bootstraps itself on first launch

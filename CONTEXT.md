# Dotfiles context for Claude Code

This file summarises all decisions made when designing this dotfiles setup.
Use it to resume work: `claude "Read CONTEXT.md and continue building the dotfiles"`

## Goal
Create a fully portable Mac setup for @kirederik (Derik Evangelista).
New machine setup should require only 3 commands:
1. `xcode-select --install`
2. `git clone git@github.com:kirederik/dotfiles.git ~/.dotfiles`
3. `cd ~/.dotfiles && ./bootstrap.sh`

## Directory: /Users/syn/derik/dotfiles
This is the working directory. All files go here.

## Tool choices and rationale

### Package management
- **Homebrew** — primary package manager, everything via Brewfile
- **chezmoi** — dotfiles manager (NOT symlinks). Files prefixed with `dot_`
  become dotfiles in `~`. e.g. `dot_zshrc` → `~/.zshrc`
- **mise** — runtime version manager, replaces nvm/pyenv/rbenv

### Shell
- **zsh** (Homebrew, not system) — POSIX compliant, team has many bash scripts
- **No oh-my-zsh** — too slow (500-1000ms startup). Use antidote instead
- **antidote** — lightweight plugin manager, reads `~/.zsh_plugins.txt`
- Three plugins only: zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
- **starship** — prompt (works across zsh/bash/fish)
- **atuin** — shell history replacement (ctrl+r)
- **zoxide** — smart cd replacement

### Runtime: bun over node
- **bun** is the primary runtime (listed first in .tool-versions)
- **node lts** kept as fallback for team script compatibility
- Only alias: `npx='bunx'` — do NOT alias `node` to `bun` (fragile)
- Use `bun` explicitly in daily work

### Version control
- **jj** (Jujutsu) — modern VCS on top of git. Git-compatible, teammates unaffected
- **git-delta** — better diffs, set as git pager
- **lazygit** — TUI git client
- **ghq** — repo organiser, clones to `~/dev/github.com/org/repo`
- **gita** — run commands across multiple repos

### Terminal
- **Ghostty** — primary terminal (fast, native, config-file driven)
- Font: Monaco Nerd Font
- Theme: catppuccin-mocha

### Editor
- **Neovim** with **LazyVim** distribution
- **Cursor** — AI IDE (daily driver for most coding)

### Multiplexer
- **Zellij** — primary (modern, floating panes, layout files)
- tmux kept in Brewfile for SSH/remote use

### Modern CLI replacements
bat→cat, eza→ls, fd→find, rg→grep, dust→du, btop→top, sd→sed, xh→curl

### Repo management
- ghq root: `~/dev`
- ctrl+g in shell → fuzzy repo jumper (ghq list | fzf)

### Git identities (auto-switched by directory)
- Personal: kirederik / kirederik@gmail.com → repos under `~/dev/github.com/kirederik/`
- Work: Derik Evangelista / derik@syntasso.io → repos under `~/dev/github.com/syntasso/`

### Home dir sync
- **chezmoi** — for dotfiles/config (git-backed)
- **Syncthing** — for Documents, notes, non-code files (continuous P2P sync)

### Browsers
- **Zen Browser** — Arc replacement (Firefox-based, open source)
- Arc kept during transition

### AI tools
- **Claude Code** — terminal agent for complex tasks
- **Cursor** — daily IDE
- Claude + ChatGPT desktop apps

## Files to create

```
dotfiles/
├── bootstrap.sh              # entry point (brew bundle + chezmoi init + macos.sh)
├── Brewfile                  # all packages and casks
├── macos.sh                  # macOS defaults (Finder, Dock, keyboard, etc.)
├── CONTEXT.md                # this file
├── .chezmoiignore            # excludes bootstrap.sh, Brewfile, macos.sh, README.md
├── dot_zshrc                 → ~/.zshrc
├── dot_zsh_plugins.txt       → ~/.zsh_plugins.txt
├── dot_gitconfig             → ~/.gitconfig
├── dot_gitconfig-personal    → ~/.gitconfig-personal
├── dot_gitconfig-work        → ~/.gitconfig-work
├── dot_tool-versions         → ~/.tool-versions
└── dot_config/
    ├── starship.toml         → ~/.config/starship.toml
    └── ghostty/
        └── config            → ~/.config/ghostty/config
```

## Key decisions / things NOT to do
- Do NOT use oh-my-zsh
- Do NOT symlink dotfiles — chezmoi handles placement
- Do NOT alias `node` to `bun` — use bun explicitly
- Do NOT use p10k/powerlevel10k — use starship
- Do NOT use nvm/pyenv/rbenv — use mise for everything
- Do NOT use exa (unmaintained) — use eza (maintained fork)
- Nvim config: LazyVim starter, cloned fresh, NOT symlinked by chezmoi
  (chezmoi manages shell/git config; nvim installs itself via LazyVim on first run)
# dotfiles

Personal macOS setup for [@kirederik](https://github.com/kirederik). Managed with [chezmoi](https://chezmoi.io), installed via a single bootstrap script.

## Fresh machine setup

Three commands, in order:

```sh
xcode-select --install
# Wait for the installer dialog to complete before continuing

git clone git@github.com:kirederik/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./bootstrap.sh
```

`bootstrap.sh` will:
1. Install Homebrew
2. Install all packages and casks from `Brewfile`
3. Apply dotfiles to `~` via chezmoi
4. Install runtimes (bun, node) via mise
5. Create `~/dev`
6. Clone the LazyVim starter into `~/.config/nvim`
7. Download the bat Catppuccin theme
8. Apply macOS system defaults

### After bootstrap

A few things that can't be automated:

| Step | Command / action |
|---|---|
| Import GPG key | `gpg --import <exported-key.asc>` |
| Enable Bitwarden SSH agent | Bitwarden → Settings → SSH Agent → enable |
| Start Syncthing | `brew services start syncthing`, then open `http://localhost:8384` to configure shares |
| VS Code / Cursor sync | Sign in to Settings Sync with GitHub in both apps |
| Logitech Options+ | Sign in — settings sync automatically via Logi account |
| Stream Deck profiles | Add `~/Library/Application Support/com.elgato.StreamDeck/ProfilesV2/` to a Syncthing share |
| Neovim plugins | Run `nvim` once — LazyVim installs everything automatically |

---

## What's managed

### Dotfiles (chezmoi → `~`)

| Source | Destination |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_zsh_plugins.txt` | `~/.zsh_plugins.txt` |
| `dot_gitconfig` | `~/.gitconfig` |
| `dot_gitconfig-personal` | `~/.gitconfig-personal` |
| `dot_gitconfig-work` | `~/.gitconfig-work` |
| `dot_gitignore_global` | `~/.gitignore_global` |
| `dot_gitmessage` | `~/.gitmessage` |
| `dot_hushlogin` | `~/.hushlogin` |
| `dot_tool-versions` | `~/.tool-versions` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/starship.toml` | `~/.config/starship.toml` |
| `dot_config/zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| `dot_config/atuin/config.toml` | `~/.config/atuin/config.toml` |
| `dot_config/bat/config` | `~/.config/bat/config` |
| `dot_config/jj/config.toml` | `~/.config/jj/config.toml` |
| `dot_docker/config.json` | `~/.docker/config.json` |
| `dot_Library/KeyBindings/DefaultKeyBinding.dict` | `~/Library/KeyBindings/DefaultKeyBinding.dict` |
| `private_dot_ssh/private_config` | `~/.ssh/config` (mode 600) |
| `private_dot_gnupg/gpg-agent.conf` | `~/.gnupg/gpg-agent.conf` (mode 600) |
| `dot_mob` | `~/.mob` (git-mob co-authors) |
| `dot_commitlintrc.json` | `~/.commitlintrc.json` |
| `dot_config/git/hooks/executable_commit-msg` | `~/.config/git/hooks/commit-msg` (mode 755) |
| `dot_tmux.conf` | `~/.tmux.conf` |
| `dot_config/karabiner/karabiner.json` | `~/.config/karabiner/karabiner.json` |
| `dot_config/karabiner.edn` | `~/.config/karabiner.edn` (Goku source for future complex rules) |
| `dot_local/bin/executable_*` | `~/.local/bin/*` (personal scripts, mode 755) |

### Not managed by chezmoi

| Config | Why | How it's handled |
|---|---|---|
| Neovim (`~/.config/nvim`) | LazyVim manages itself | Cloned fresh in bootstrap |
| VS Code / Cursor settings | Built-in Settings Sync | Sign in with GitHub |
| Logitech Options+ | Built-in cloud sync | Sign in with Logi account |
| Zoom | Account-based | Sign in |
| Stream Deck profiles | Binary, changes frequently | Syncthing |
| Documents / notes | Not code | Syncthing |

---

## Tool choices

### Shell

| Tool | Replaces | Why |
|---|---|---|
| zsh (Homebrew) | system zsh | Kept current, consistent across machines |
| [antidote](https://antidote.sh) | oh-my-zsh | Lightweight, <50ms startup |
| [starship](https://starship.rs) | p10k | Cross-shell, config-file driven |
| [atuin](https://atuin.sh) | ctrl+r | Searchable, deduplicated history |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | cd | Jumps to frecent dirs |
| [direnv](https://direnv.net) | manual exports | Per-project env vars via `.envrc` |

### Version control

| Tool | Purpose |
|---|---|
| [jujutsu (`jj`)](https://github.com/jj-vcs/jj) | Primary VCS — git-compatible, better UX |
| [git-delta](https://github.com/dandavison/delta) | Diff pager |
| [lazygit](https://github.com/jesseduffield/lazygit) | TUI git client |
| [ghq](https://github.com/x-motemen/ghq) | Repo organiser — clones to `~/dev/github.com/org/repo` |
| [gita](https://github.com/nosarthur/gita) | Run commands across multiple repos |
| [git-mob](https://github.com/git-mob/git-mob) | Co-author tracking for pair/mob programming |

### Modern CLI

| Alias | Replaces | Tool |
|---|---|---|
| `cat` | cat | [bat](https://github.com/sharkdp/bat) |
| `ls` / `ll` / `la` | ls | [eza](https://github.com/eza-community/eza) |
| `grep` | grep | [ripgrep](https://github.com/BurntSushi/ripgrep) |
| `du` | du | [dust](https://github.com/bootandy/dust) |
| `top` | top | [btop](https://github.com/aristocratsofcode/btop) |
| `curl` | curl | [xh](https://github.com/ducaale/xh) |
| `npx` | npx | bunx |

`fd` and `sd` are installed but not aliased — too risky to override `find` and `sed` globally due to scripted usage.

### Runtimes

Managed by [mise](https://mise.jdx.dev) via `~/.tool-versions`:

```
bun 1       # primary runtime
node lts    # fallback for team script compatibility
go latest   # Go — also drives go-tools.sh installs
```

### Go tools

`go-tools.sh` installs tools that aren't in Homebrew. It runs automatically during bootstrap and can be re-run any time to update:

```sh
./go-tools.sh
```

Tools managed by the editor (gopls, dlv) are intentionally excluded — LazyVim and Cursor install those themselves.

Three Go tools come from Homebrew instead (updated with `brew upgrade`):

| Tool | Why Homebrew |
|---|---|
| `golangci-lint` | Complex install, official Homebrew tap |
| `goreleaser` | Same |
| `golang-migrate` | Available and stable in Homebrew |

**goreleaser-pro**: install separately — it requires a licence key:
```sh
brew install goreleaser/tap/goreleaser-pro
# Add GORELEASER_KEY to a project-level .envrc (never commit it)
```

---

## Key bindings

### Shell

| Key | Action |
|---|---|
| `ctrl+r` | Fuzzy shell history search (atuin) |
| `ctrl+g` | Fuzzy repo jump (`ghq` + `fzf`) |
| `ctrl+t` | Paste file path (fzf) |
| `alt+c` | cd into dir (fzf) |
| `ctrl+w` | Delete word backward (system-wide, all Cocoa apps) |

---

### Zellij

Primary multiplexer. Uses `Ctrl+Space` as a prefix — press it to arm, then the next key acts and drops back to Normal. Powered by [zellij-autolock](https://github.com/fresh2dev/zellij-autolock): Zellij automatically locks (passes all keys through) when `nvim`, `lazygit`, `k9s`, `fzf`, etc. are focused. `Ctrl+g` to manually unlock.

#### Prefix bindings (`Ctrl+Space` → key)

**Pane navigation**

| Keys | Action |
|---|---|
| `Ctrl Space` → `h/j/k/l` | Move focus left / down / up / right |
| `Ctrl Space` → `o` | Cycle to next pane |
| `Ctrl Space` → `z` | Zoom (fullscreen) focused pane |
| `Ctrl Space` → `x` | Close focused pane |

**New panes**

| Keys | Action |
|---|---|
| `Ctrl Space` → `v` | New pane to the right (vertical split) |
| `Ctrl Space` → `-` | New pane below (horizontal split) |
| `Ctrl Space` → `f` | New floating pane |

**Tabs (windows)**

| Keys | Action |
|---|---|
| `Ctrl Space` → `c` | New tab |
| `Ctrl Space` → `n` / `p` | Next / previous tab |
| `Ctrl Space` → `Tab` | Previous tab (last window) |
| `Ctrl Space` → `<` / `>` | Move tab left / right |

**Other**

| Keys | Action |
|---|---|
| `Ctrl Space` → `[` | Enter scroll mode (copy mode) |
| `Ctrl Space` → `s` / `g` | Session manager |
| `Ctrl Space` → `Esc` | Cancel / disarm prefix |

#### Scroll mode (`Ctrl Space` → `[`)

| Key | Action |
|---|---|
| `j` / `k` | Scroll down / up |
| `Ctrl d` / `Ctrl u` | Half-page down / up |
| `Ctrl f` / `Ctrl b` | Full-page down / up |
| `g` / `G` | Jump to top / bottom |
| `/` | Search |
| `n` / `N` | Next / previous search match |
| `e` | Open scrollback in `$EDITOR` |
| `q` / `Esc` | Exit scroll mode |

#### Mode UI (`Ctrl` + key, no prefix needed)

| Keys | Mode |
|---|---|
| `Ctrl p` | Pane mode — `v`/`-`/`x`/`z`/`f`/`r` without modifiers |
| `Ctrl t` | Tab mode — `n`/`x`/`h`/`l`/`<`/`>`/`r` |
| `Ctrl n` | Resize mode — `h`/`j`/`k`/`l` (grow), `H`/`J`/`K`/`L` (shrink) |
| `Ctrl o` | Session manager |
| `Ctrl g` | Unlock (exit Locked mode) |
| `Ctrl q` | Quit Zellij |

---

### tmux

Kept for SSH and remote use. Same prefix (`Ctrl+Space`).

#### Prefixed bindings (`Ctrl+Space` → key)

| Keys | Action |
|---|---|
| `Ctrl Space` → `Ctrl Space` | Last window |
| `Ctrl Space` → `v` | New vertical split (current path) |
| `Ctrl Space` → `r` | Reload `~/.tmux.conf` |
| `Ctrl Space` → `=` | Choose paste buffer |

**Copy mode** (enter with `C-M-[` or `Ctrl Space` → `[` isn't bound in tmux — use `C-M-[`)

| Key | Action |
|---|---|
| `v` | Begin selection |
| `y` | Copy selection and exit |
| `/` / `?` | Search forward / backward (replaces tmux-copycat) |
| `n` / `N` | Next / previous match |

**tmux-open** (in copy mode, with text selected)

| Key | Action |
|---|---|
| `O` | Open file or URL |
| `Ctrl o` | Open in `$EDITOR` |

#### Unprefixed bindings (no prefix needed)

**Pane navigation**

| Keys | Action |
|---|---|
| `C-M-h/j/k/l` | Move focus left / down / up / right |
| `C-M-o` | Cycle to next pane |
| `C-M-x` | Kill pane (with confirmation) |
| `C-M-z` | Zoom (fullscreen) pane |
| `C-M-\` | Toggle synchronize-panes |

**Window navigation**

| Keys | Action |
|---|---|
| `C-M-n` / `C-M-p` | Next / previous window |
| `M-Tab` | Last window |
| `M-<` / `M->` | Swap window left / right |

**Copy / paste**

| Keys | Action |
|---|---|
| `C-M-[` | Enter copy mode |
| `C-M-]` | Paste buffer |
| `C-M-c` | Clear pane and scroll history |

**Layouts / misc**

| Keys | Action |
|---|---|
| `C-M-Space` | Next layout |
| `C-M-r` | Reload `~/.tmux.conf` |
| `M-;` | Last pane |
| `M-:` | Command prompt |

---

## Git identity switching

Identity is switched automatically based on repo path:

| Path | Identity |
|---|---|
| `~/dev/github.com/kirederik/**` | kirederik / kirederik@gmail.com |
| `~/dev/github.com/syntasso/**` | Derik Evangelista / derik@syntasso.io |

Clone repos under the right path to get the right identity automatically:

```sh
ghq get github.com/kirederik/my-project    # → ~/dev/github.com/kirederik/my-project
ghq get github.com/syntasso/kratix         # → ~/dev/github.com/syntasso/kratix
```

---

## SSH

SSH keys are stored in [Bitwarden](https://bitwarden.com). The Bitwarden desktop app acts as an SSH agent — no key files on disk.

**Requirements:**
- Bitwarden desktop app running
- Settings → SSH Agent → enabled

`SSH_AUTH_SOCK` is only overridden when the Bitwarden socket exists, so SSH degrades gracefully when the app isn't running.

`~/.ssh/config` sets `ControlMaster auto` globally, so repeated connections to the same host (e.g. multiple `git push`) reuse a single SSH session.

---

## Kubernetes

### Tools

| Tool | Source | Purpose |
|---|---|---|
| `kubectl` | Homebrew | CLI |
| `kubectx` / `kubens` | Homebrew | Context and namespace switching (`kx`, `kn`) |
| `k9s` | Homebrew | TUI cluster browser |
| `stern` | Homebrew | Multi-pod log tailing |
| `kubeseal` | Homebrew | Sealed secrets CLI |
| krew plugins | `kube-tools.sh` | See below |

Useful aliases already in `.zshrc`:

```sh
k   → kubectl
kx  → kubectx
kn  → kubens
kp  → kubectl --context kind-platform
kw  → kubectl --context kind-work
```

`k` also gets full tab completion via `compdef k=kubectl`.

### krew plugins

`kube-tools.sh` installs plugins and can be re-run to pick up additions:

```sh
./kube-tools.sh
```

| Plugin | Purpose |
|---|---|
| `neat` | Strip managed fields from YAML — essential for reading CRDs |
| `tree` | Show resource ownership hierarchy (great for operators/Kratix) |
| `images` | List all container images running in the cluster |
| `resource-capacity` | Node/pod resource requests and limits at a glance |
| `df-pv` | Disk usage of PersistentVolumes |
| `who-can` | Which subjects can perform a given action |
| `access-matrix` | Full RBAC matrix for a namespace |
| `view-secret` | Decode secret values inline |
| `get-all` | Every resource in a namespace, including CRDs |

### kubeconfig

`~/.kube/config` is **not** managed by chezmoi — it's machine-specific. Copy it manually or let the cloud provider CLI regenerate it (`gcloud`, `aws eks`, etc.).

---

## Conventional Commits

commitlint runs as a global git hook on every commit across all repos.

**Config**: `~/.commitlintrc.json` extends `@commitlint/config-conventional`.

**Hook**: `~/.config/git/hooks/commit-msg` — installed via `core.hooksPath` in `.gitconfig`, so no per-repo setup is needed.

Format:
```
<type>(optional scope): <subject>

feat: add support for Promise resources
fix(scheduler): handle nil pointer on timeout
docs: update contributing guide
chore: bump golangci-lint to v1.57
```

Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`.

**To bypass in an emergency** (use sparingly):
```sh
git commit --no-verify -m "wip: temp"
```

---

## Custom scripts

Personal scripts live in `dot_local/bin/` and are deployed to `~/.local/bin/`, which is already on `PATH`.

**Adding a script:**

```sh
# In the dotfiles repo:
cp ~/my-script ~/.dotfiles/dot_local/bin/executable_my-script
# The executable_ prefix tells chezmoi to deploy it with +x permissions.
# No other setup needed — it'll be on PATH after chezmoi apply.
```

**Naming convention:**

| chezmoi source | deployed as | permissions |
|---|---|---|
| `dot_local/bin/executable_foo` | `~/.local/bin/foo` | `755` |
| `dot_local/bin/executable_private_foo` | `~/.local/bin/foo` | `700` |

Scripts are plain files — commit them like any other code. If a script grows into something worth sharing, move it to its own repo under `~/dev/github.com/kirederik/`.

---

## git-mob

Co-author configuration lives in `~/.git-coauthors` (managed by chezmoi via `dot_git-coauthors`).

**Exporting co-authors from an existing machine:**

```sh
cat ~/.git-coauthors   # copy this JSON into dot_git-coauthors in the repo
```

**Daily use:**

```sh
git mob cat          # start mobbing with cat
git solo             # back to working alone
git mob --list       # see all configured co-authors
```

**Adding a new co-author:**

Edit `dot_git-coauthors` in the repo directly, then `chezmoi apply`. The format is:

```json
{
  "coAuthors": {
    "initials": {
      "name": "Full Name",
      "email": "email@example.com"
    }
  }
}
```

---

## Updating dotfiles

```sh
# Edit files in ~/.dotfiles, then apply:
chezmoi apply

# Or re-run the full bootstrap (idempotent):
cd ~/.dotfiles && ./bootstrap.sh
```

To update packages:

```sh
brew upgrade
brew cleanup
```

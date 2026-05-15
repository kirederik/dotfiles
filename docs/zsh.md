# Shell (zsh)

Plugin manager: **antidote** (reads `~/.zsh_plugins.txt`). Prompt: **starship**.

## Keybindings

| Key | Action | Source |
|---|---|---|
| `ctrl+r` | Fuzzy shell history search | atuin |
| `ctrl+g` | Fuzzy repo jump (`ghq` + `fzf`) | custom widget |
| `ctrl+t` | Paste file path | fzf |
| `alt+c` | `cd` into dir | fzf |
| `↑` / `↓` | Prefix-aware history search | zsh built-in |
| `ctrl+w` | Delete word backward (stops at `/`) | `WORDCHARS` setting |
| `ctrl+a` / `ctrl+e` | Beginning / end of line | zsh readline |
| `ctrl+k` | Delete to end of line | zsh readline |
| `alt+.` | Insert last argument | zsh readline |

> `ctrl+a/e/k` are explicitly bound after all plugins to ensure nothing overrides them (especially important inside Zellij).

---

## Aliases

### Modern CLI replacements

| Alias | Replaces | Tool |
|---|---|---|
| `cat` | cat | bat |
| `ls` / `ll` / `la` | ls | eza |
| `lt` / `tree` | tree | eza --tree |
| `grep` | grep | ripgrep |
| `du` | dust | dust |
| `top` | top | btop |
| `curl` | curl | xh |
| `vi` / `vim` | vim | nvim |
| `npx` | npx | bunx |

Originals accessible as `gcat`, `gls`, `ggrep`, `gsed`.

### Git

| Alias | Expands to |
|---|---|
| `g` | git |
| `lg` | lazygit |

### Homebrew

| Alias | Effect |
|---|---|
| `brewup` | `brew bundle install` + `brew bundle cleanup --force` — syncs installed packages to Brewfile |

### Maintenance

| Command | Updates |
|---|---|
| `brewup` | Homebrew packages (install missing, remove unlisted) |
| `toolsup` | mise runtimes (Go, Node, Ruby, Bun) · pipx packages · krew plugins |

### Zellij sessions

| Alias/Function | Effect |
|---|---|
| `zj [name]` | Smart attach: fzf picker if multiple sessions, direct attach if one, new session if none. Pass a name to start a named session. |
| `zjk` | Kill a session via fzf |
| `zjd` | Delete a session via fzf |
| `zjl` | List sessions |

---

## Functions

### `mob`

Wraps `git mob` and keeps jj in sync (both track co-authors):

```sh
mob cat alice       # start mobbing with cat and alice
mob                 # end session (clears co-authors)
```

### TUI autolock (`_zellij_wrap`)

`nvim`, `vim`, `lazygit`, `k9s`, `btop` are wrapped so Zellij automatically enters Locked mode (all keys pass through) when they launch, and returns to Normal mode when they exit.

Only persistent TUI apps belong here — short-lived launchers that spawn fzf as a child (like `fzf-make`) fight with the mode-switching timing and should be excluded.

Manual override: `ctrl+g` to unlock mid-session without exiting the app.

---

## Options

| Option | Effect |
|---|---|
| `AUTO_CD` | Type a dir name to cd into it |
| `CORRECT` | Suggest corrections for mistyped commands |
| `NO_BEEP` | Silence all bells |
| `GLOB_DOTS` | Include dotfiles in glob matches |
| `WORDCHARS` | Excludes `/` so ctrl+w stops at path separators |

---

## Starship prompt

Format: `directory  [jj change]  [git branch]  [git status]  [language versions]  ──  [duration]`

| Segment | Shows |
|---|---|
| Directory | Truncated to 4 levels, repo root |
| jj | `⬡ change_id (bookmark) description` |
| git branch | Branch name (hidden in jj repos — detached HEAD suppressed) |
| git status | `+` staged `!` modified `?` untracked `✘` deleted |
| Language | Node, Bun, Go, Rust, Python (detected by project files) |
| Duration | Commands taking > 2s |

---

## UK keyboard notes (Ghostty)

`macos-option-as-alt = left` makes the left Option key act as Alt for terminal use (enabling `alt+.`, `alt+c`, etc.). Right Option still does macOS character composition.

Side effect: `alt+3` no longer produces `#`. Fixed with: `keybind = alt+3=text:#` in Ghostty config.

# Zellij

Primary terminal multiplexer. Uses Zellij's built-in **Tmux mode** as a one-shot prefix layer: `Ctrl+Space` arms the leader, the next key acts, then drops back to Normal.

Theme: Catppuccin Mocha.

---

## TUI autolock

`nvim`, `vim`, `lazygit`, `k9s`, and `btop` are wrapped in shell functions that:
1. Switch Zellij to **Locked mode** before launching (all keys pass through to the app)
2. Return to **Normal mode** when the app exits

This is implemented as shell wrappers in `~/.zshrc` — **not** a plugin.

Manual controls:
- `ctrl+g` — unlock (Locked → Normal)
- `Ctrl+Space` → `l` — re-lock (Normal → Locked)
- `zlock` — re-lock from the terminal prompt
- `<leader>zl` — re-lock from inside nvim

> **Note:** `atuin` and `fzf` are intentionally excluded from the wrap list — atuin installs zsh hooks that fire on every keystroke, which would cause constant mode-switching.

---

## Keybindings

### Prefix bindings (`Ctrl+Space` → key)

**Panes**

| Keys | Action |
|---|---|
| `h` / `j` / `k` / `l` | Focus left / down / up / right |
| `o` | Cycle to next pane |
| `z` | Zoom (fullscreen) focused pane |
| `x` | Close focused pane |
| `v` | New pane to the right (vertical split) |
| `-` | New pane below (horizontal split) |
| `f` | New floating pane |

**Tabs**

| Keys | Action |
|---|---|
| `c` | New tab |
| `n` / `p` | Next / previous tab |
| `Tab` | Jump to previous tab |
| `<` / `>` | Move tab left / right |

**Other**

| Keys | Action |
|---|---|
| `[` | Enter scroll/copy mode |
| `s` / `g` | Session manager |
| `l` | Enter Locked mode (pass-through) |
| `Esc` | Cancel / disarm prefix |

---

### Scroll / copy mode (`Ctrl+Space` → `[`)

| Key | Action |
|---|---|
| `j` / `k` | Scroll down / up |
| `Ctrl+d` / `Ctrl+u` | Half-page down / up |
| `Ctrl+f` / `Ctrl+b` | Full-page down / up |
| `g` / `G` | Jump to top / bottom |
| `/` | Search |
| `n` / `N` | Next / previous match |
| `e` | Open scrollback in `$EDITOR` |
| `q` / `Esc` | Exit scroll mode |

---

### Mode keys (no prefix, `Ctrl` + key)

| Keys | Mode |
|---|---|
| `Ctrl+p` | Pane mode — `v`/`-`/`x`/`z`/`f`/`r` |
| `Ctrl+t` | Tab mode — `n`/`x`/`h`/`l`/`<`/`>`/`r` |
| `Ctrl+n` | Resize mode — `h`/`j`/`k`/`l` grow, `H`/`J`/`K`/`L` shrink |
| `Ctrl+o` | Session manager |
| `Ctrl+g` | Unlock (Locked → Normal) |
| `Ctrl+q` | Quit Zellij |

---

### Shell passthrough (Normal mode)

These are wired directly so they reach the shell even in Normal mode:

| Key | Shell action |
|---|---|
| `Ctrl+a` | Beginning of line |
| `Ctrl+e` | End of line |
| `Ctrl+k` | Kill to end of line |
| `Alt+.` | Insert last argument |
| `Ctrl+g` | `ghq` fuzzy repo jump |

---

## Session management

```sh
zj              # attach to existing session (fzf if multiple), or start new
zj myproject    # start/attach named session
zjk             # kill a session via fzf
zjd             # delete a session via fzf
zjl             # list all sessions
```

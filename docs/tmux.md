# tmux

Kept for SSH and remote use. Same `Ctrl+Space` prefix as Zellij.

---

## Prefix bindings (`Ctrl+Space` → key)

| Keys | Action |
|---|---|
| `Ctrl+Space` | Last window |
| `v` | New vertical split (current path) |
| `r` | Reload `~/.tmux.conf` |
| `=` | Choose paste buffer |

---

## Unprefixed bindings

### Panes

| Keys | Action |
|---|---|
| `C-M-h/j/k/l` | Move focus left / down / up / right |
| `C-M-o` | Cycle to next pane |
| `C-M-x` | Kill pane (with confirmation) |
| `C-M-z` | Zoom pane |
| `C-M-\` | Toggle synchronize-panes |

### Windows

| Keys | Action |
|---|---|
| `C-M-n` / `C-M-p` | Next / previous window |
| `M-Tab` | Last window |
| `M-<` / `M->` | Swap window left / right |

### Copy / paste

| Keys | Action |
|---|---|
| `C-M-[` | Enter copy mode |
| `C-M-]` | Paste buffer |
| `C-M-c` | Clear pane and scroll history |

### Misc

| Keys | Action |
|---|---|
| `C-M-Space` | Next layout |
| `C-M-r` | Reload config |
| `M-;` | Last pane |
| `M-:` | Command prompt |

---

## Copy mode (`C-M-[`)

| Key | Action |
|---|---|
| `v` | Begin selection |
| `y` | Copy selection and exit |
| `/` / `?` | Search forward / backward |
| `n` / `N` | Next / previous match |
| `O` | Open file or URL |
| `Ctrl+o` | Open in `$EDITOR` |

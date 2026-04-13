# Neovim / LazyVim

Distribution: **LazyVim**. Config lives in `~/.dotfiles/dot_config/nvim/` (managed by chezmoi). Plugins and their data are self-managed by LazyVim — not tracked in dotfiles.

Theme: Catppuccin Mocha.

---

## Setup

On a new machine, run `nvim` once after `chezmoi apply` — LazyVim bootstraps itself. Then:

```sh
:Copilot auth    # authenticate GitHub Copilot
:Mason           # verify LSP servers installed
:Lazy            # plugin manager UI
:LazyExtras      # browse/toggle LazyVim extras
```

---

## Language support

Configured via LazyVim extras in `lua/config/lazy.lua`:

| Extra | Provides |
|---|---|
| `lang.go` | gopls, delve debugger, golangci-lint, gofmt |
| `lang.ruby` | ruby-lsp, rubocop |
| `lang.python` | pyright, ruff |
| `lang.typescript` | ts_ls, eslint |
| `lang.yaml` | yaml-language-server |
| `lang.json` | json-language-server |
| `lang.markdown` | marksman, render-markdown |
| `lang.docker` | docker-langserver |

Additional servers in `lua/plugins/lang.lua`:

| Server | Purpose |
|---|---|
| `html` | HTML completion and diagnostics |
| `emmet_ls` | Emmet abbreviation expansion (HTML, JSX, CSS…) |
| `bashls` | Bash/shell script LSP |
| `golangci-lint` | Go multi-linter (uses Homebrew binary) |
| `markdownlint-cli2` | Markdown lint |
| `vale` | Prose linter |

---

## Copilot

Plugin: `zbirenbaum/copilot.lua` (native ghost text, no nvim-cmp/blink integration).

| Key | Action |
|---|---|
| `Tab` | Accept suggestion (insert mode, only when ghost text is visible) |
| `Ctrl+Right` | Accept next word |
| `Alt+]` / `Alt+[` | Next / previous suggestion |
| `Ctrl+]` | Dismiss suggestion |

Ghost text is hidden while a completion popup is open (`hide_during_completion = true`).

---

## Keybindings (custom)

| Key | Mode | Action |
|---|---|---|
| `Enter` | Normal | Save file (`:w`) |
| `<leader>um` | Normal | Toggle Markdown inline render |
| `gwip` | Normal | Reflow current paragraph to `textwidth` |
| `gwap` | Normal | Reflow paragraph + surrounding blank lines |

> `gw` (not `gq`) is preferred for prose — it always uses the built-in reflow algorithm rather than the LSP formatter. `textwidth` is set to 80.

---

## Settings

| Setting | Value | Effect |
|---|---|---|
| `textwidth` | 80 | Column for `gw`/`gq` reflow |
| `colorcolumn` | 81 | Ruler at the wrap boundary |

---

## Plugins overview

| File | Purpose |
|---|---|
| `lua/config/lazy.lua` | Plugin spec, LazyVim extras, lazy.nvim settings |
| `lua/config/keymaps.lua` | Custom keymaps (Enter to save, etc.) |
| `lua/config/options.lua` | Custom options (textwidth, colorcolumn) |
| `lua/plugins/lang.lua` | Extra LSPs, Mason packages, golangci-lint, markdown render, pyright suppression |
| `lua/plugins/copilot.lua` | GitHub Copilot ghost text |
| `lua/plugins/theme.lua` | Catppuccin Mocha theme |

---

## Notes

- **Pyright progress**: suppressed via a noice.nvim route — `Pyright: Checking...` messages are hidden.
- **Markdown render**: `render-markdown.nvim` is disabled by default (it mixes preview and raw syntax). Toggle with `<leader>um`.
- **LazyVim extras**: manage via `:LazyExtras` UI. After changes, run `chezmoi re-add ~/.config/nvim/lazyvim.json`.
- **Mason plugin name**: `mason-org/mason.nvim` (renamed from `williamboman/mason.nvim`).

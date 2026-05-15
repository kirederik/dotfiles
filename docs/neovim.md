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
| `helm_ls` | Helm chart templates — `.Values.*` completions, built-in functions, hover docs. Filetype detection in `options.lua` maps `templates/*.yaml` → `helm` so yamlls (which breaks on `{{ }}`) stays silent. |

---

## Copilot

Plugin: `zbirenbaum/copilot.lua` + `blink-cmp-copilot`. Copilot suggestions appear as items inside the blink.cmp completion popup (labelled "Copilot", ranked above LSP results) — no separate ghost-text layer, no overlapping UIs. Accept with the normal blink.cmp confirm key (`Enter`).

---

## Task runner (overseer)

Run arbitrary shell commands from inside nvim and re-run them on demand.

| Key | Action |
|---|---|
| `<leader>or` | Run a command or pick a task template |
| `<leader>ow` | Toggle the task output panel |
| `<leader>oR` | Re-run the last task |
| `<leader>oa` | Task action menu (stop, restart, edit…) |

Useful for: `bats ./test/`, `ginkgo ./pkg/...`, `make test`, `helm template .`, etc.

---

## Testing (neotest)

Go tests run via `neotest` + `neotest-go`. Results appear inline next to test functions.

| Key | Action |
|---|---|
| `<leader>tt` | Run test nearest to cursor |
| `<leader>tT` | Run all tests in file |
| `<leader>tp` | Run all tests in package (use this for Ginkgo) |
| `<leader>tr` | Re-run last test |
| `<leader>ts` | Toggle test summary panel |
| `<leader>to` | Show test output |
| `<leader>tO` | Toggle output panel |
| `<leader>tS` | Stop test run |

> **Ginkgo:** Two adapters are active — `neotest-go` for `func TestXxx` functions and `neotest-ginkgo` for Ginkgo v2 `Describe`/`It` spec files. Use `<leader>tp` to run all tests in the package (works for both). The neotest summary (`<leader>ts`) shows the full Ginkgo spec hierarchy with pass/fail. For full Ginkgo output with colors, use `<leader>tg` (sends to Zellij run tab).

---

## Keybindings (custom)

| Key | Mode | Action |
|---|---|---|
| `Enter` | Normal | Save file (`:w`) |
| `<leader>um` | Normal | Toggle Markdown inline render |
| `<leader>zl` | Normal | Lock Zellij session (no-op outside Zellij) |
| `gwip` | Normal | Reflow current paragraph to `textwidth` |
| `gwap` | Normal | Reflow paragraph + surrounding blank lines |

> `gw` (not `gq`) is preferred for prose — it always uses the built-in reflow algorithm rather than the LSP formatter. `textwidth` is set to 80.

---

## Zellij split-pane runner

Commands run in a right-split pane in the **same Zellij tab** as the nvim instance that triggered them. Each tab gets its own run pane — multiple nvim instances in different tabs are fully independent. Falls back to a terminal split inside nvim when not in Zellij.

| Key | Action |
|---|---|
| `<leader>tg` | Ginkgo: run current package (`ginkgo -v <dir>`) |
| `<leader>tG` | Ginkgo: run all packages recursively (`ginkgo -v -r ./...`) |
| `<leader>tb` | Bats: run current file |
| `<leader>tx` | Prompt for any command and run it in the split pane |

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
| `lua/overseer/strategy/zellij.lua` | Overseer strategy: routes tasks to Zellij "run" tab |
| `lua/plugins/theme.lua` | Catppuccin Mocha theme |

---

## Notes

- **Pyright progress**: suppressed via a noice.nvim route — `Pyright: Checking...` messages are hidden.
- **Markdown render**: `render-markdown.nvim` is disabled by default (it mixes preview and raw syntax). Toggle with `<leader>um`.
- **LazyVim extras**: manage via `:LazyExtras` UI. After changes, run `chezmoi re-add ~/.config/nvim/lazyvim.json`.
- **Mason plugin name**: `mason-org/mason.nvim` (renamed from `williamboman/mason.nvim`).

# Herdr

Agent-aware terminal workspace manager (`brew 'herdr'`). Hierarchy is **workspace → tab → pane**, and it recognises coding agents inside panes, tracking their lifecycle in a sidebar. Being migrated to from Zellij — see [Zellij](zellij.md), which stays installed as a fallback.

Config: `dot_config/herdr/config.toml` → `~/.config/herdr/config.toml`.
Theme: Catppuccin (matched to Zellij).

---

## Relationship to Zellij

Herdr is not a Zellij replacement feature-for-feature — it's a multiplexer built around agents. What it adds: agent lifecycle state, an attention queue, desktop/sound notifications, agent session resume across server restarts, `herdr --remote` SSH attach, and a scriptable socket API where an agent can drive other agents.

What Zellij has that Herdr doesn't: floating panes (Herdr has popups via `[[keys.command]]`), KDL layout files, swap layouts. Neither matters much here — the Zellij setup uses zero third-party plugins and a 171-byte default layout.

Zellij's **Locked mode is not needed**: Herdr only intercepts the prefix key, so TUIs receive every other key. The `_zellij_wrap` auto-lock functions in `.zshrc` are guarded by `[[ -n $ZELLIJ ]]` and correctly no-op here.

**Do not nest.** `experimental.allow_nested = false` blocks Herdr-in-Herdr; Herdr inside Zellij would stack prefixes.

---

## Keybindings

Prefix is `Ctrl+Space` — same leader as Zellij's tmux mode, so muscle memory transfers. Actions are tmux-shaped.

**Panes**

| Keys | Action |
|---|---|
| `h` / `j` / `k` / `l` | Focus left / down / up / right |
| `Tab` / `Shift+Tab` | Cycle pane next / previous |
| `z` | Zoom focused pane |
| `x` | Close focused pane |
| `v` | Split right |
| `-` | Split down |
| `r` | Resize mode |
| `Shift+P` | Rename pane |

**Tabs & workspaces**

| Keys | Action |
|---|---|
| `c` | New tab |
| `n` / `p` | Next / previous tab |
| `1`–`9` | Switch to tab N |
| `Shift+X` | Close tab |
| `w` | Workspace picker |
| `g` | Navigate mode (goto) |
| `Shift+N` | New workspace |
| `Shift+G` | New git worktree workspace — **see the jj caveat below** |

**Other**

| Keys | Action |
|---|---|
| `a` / `Shift+A` | Next / previous agent |
| `Alt+1`–`Alt+9` | Focus agent row N (**left** Option only — `macos-option-as-alt = left`) |
| `o` | Jump to the last notification's source — the closest thing to "go to what needs me" |
| `?` | Help |
| `s` | Settings |
| `q` | Detach |
| `b` | Toggle sidebar |
| `e` | Edit scrollback |
| `Shift+R` | Reload config |
| `Alt+J` | Refresh the jj sidebar rows on demand |

Validate config changes with `herdr server reload-config` — it returns `status: "applied"` with empty `diagnostics` on success, or `"partial"` plus a message on a bad binding.

---

## Agent lifecycle

Sidebar states: `idle` (ready for input, tab has been seen), `working`, `blocked` (approval/question UI detected), `done` (idle after unseen background work), `unknown` (agent present but unclassified — **not** proof of completion).

`blocked` is the "waiting on you" state. `prefix+O` jumps to whatever raised the last notification, which requires `[ui.toast] delivery` to be something other than `off` — the default. Whether `next_agent` traverses the attention queue or plain panel order is undocumented; `[ui] agent_panel_sort = "priority"` reorders the panel *into* an attention queue (versus `"spaces"`, grouped by workspace), so flip it if `prefix+a` cycles in an order that doesn't match urgency.

**No nested keybindings.** Herdr has no user-definable sub-modes and no chord sequences — `navigate` (`prefix+g`) and `resize` (`prefix+r`) are hardcoded modes whose local keys can only be remapped. `prefix+a n`, `prefix+a shift+n` and `prefix+a 1..9` are all rejected by the parser with `invalid keybinding … disabling binding`, so agent navigation has to be single-step.

### Claude Code integration

```bash
herdr integration install claude   # run once per machine
herdr integration status           # should read: claude: current (vN)
```

Writes `~/.claude/hooks/herdr-agent-state.sh` and a `SessionStart` hook into `~/.claude/settings.json`. The hook config is tracked in `dot_claude/private_settings.json` with a `~`-relative path for portability; the script itself is **not** tracked, since Herdr versions and upgrades it. It self-disables outside Herdr (`[ "${HERDR_ENV:-}" = "1" ] || exit 0`), so it's harmless on machines without Herdr.

It reports **session identity only** (enabling resume across server restarts), not live state — state detection stays heuristic.

---

## jj (Jujutsu)

Herdr's repo model is **git-only**, which matters because jj is the primary VCS here. Two verified consequences:

1. **`herdr worktree create` / `prefix+Shift+G` produces a jj-less checkout** in a colocated repo. It runs `git worktree add`, so the new directory has `.git` but no `.jj` — `jj status` there fails with `There is no jj repo in "."`. It also creates a real git branch, which the main repo imports as a bookmark on the next `jj` command. **Avoid it in jj repos.**
2. **`jj workspace add` output is invisible to `herdr worktree`.** A jj workspace has `.jj` but no `.git`, so `herdr worktree open --path …` returns `worktree_not_found`.

### Use `jw` instead of Herdr worktrees

`brew 'EzraCerpac/tap/jj-waltz'` provides `jw` (prebuilt binary — no Rust toolchain needed):

```bash
jw add <name>                       # create a jj workspace
jw switch <name>                    # switch to / create one (aliases: s, ^, -)
jw list                             # list workspaces
herdr workspace create --cwd "$(jw path <name>)" --label <name> --no-focus
```

### Sidebar status: `mroth.jj-status`

Herdr's built-in `branch` / `git_status` tokens read git HEAD, which jj parks **detached** in colocated repos — so they show a bare hash, not the bookmark. The plugin fills the gap:

```bash
herdr plugin install mroth/herdr-jj-status   # shell only; needs jj + jq on PATH
herdr plugin action invoke refresh --plugin mroth.jj-status
```

Its `$jj_bookmark` / `$jj_status` tokens are wired into `[ui.sidebar.spaces]` in `config.toml`. Reading:

| Token | Meaning |
|---|---|
| `main` | on bookmark `main` |
| `main:: @rx` | descendant of `main`, at change `rx` |
| `@rx` | no bookmark anywhere |
| `name??` / `@id??` | conflicted bookmark / divergent change |
| `! ↑2↓1 *3` | conflict · 2 ahead / 1 behind remote · 3 changed files |

**Refreshing.** The plugin subscribes to `workspace.focused` plus one-shot lifecycle events (`startup`, `workspace.created`, `worktree.created`, `worktree.opened`) — there is no polling. Out of the box that means a `jj commit` or `jj bookmark set` leaves the row stale until you leave and re-enter the space. Two additions fix that:

- **`precmd` hook** in `.zshrc`, guarded on `$HERDR_ENV` — fires the refresh after every command in a Herdr pane. `plugin action invoke` is fire-and-forget (queues server-side, returns in ~12ms), so there's no prompt latency. Also re-evaluates on `cd`, which matters given the pane-cwd behaviour below.
- **`prefix+Alt+J`** (`[[keys.command]]`, `type = "shell"`) for an on-demand sweep when a repo changes underneath you.

Notes:
- Every `jj` call uses `--ignore-working-copy`, so refreshing never snapshots or mutates the working copy. Trade-off: the file count reflects the last snapshot, so it reads exactly one refresh behind if nothing else has snapshotted. The precmd hook plus a jj-aware prompt makes this invisible in practice.
- The `refresh` action has no per-workspace scoping — each fire sweeps *every* workspace. Negligible at 3–4 workspaces; worth revisiting past ~15.
- The plugin reads **pane cwd**; Herdr's built-in `branch`/`git_status` read the workspace's detected **`repo_root`**. A pane that `cd`s out of the repo blanks the jj row while the git row persists — which is why both rows are kept.
- Plugin artifacts are not chezmoi-tracked (`.plugins.lock` is empty even after install), so re-run the install command on a new machine.

---

## Scripting agents

Herdr's CLI is the reason to script it at all — most commands return JSON with opaque stable IDs (`w1`, `w1:t1`, `w1:p1`). Inside a pane, `$HERDR_WORKSPACE_ID` / `$HERDR_TAB_ID` / `$HERDR_PANE_ID` identify the caller.

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
herdr agent start reviewer --kind claude --pane <pane_id>
herdr agent prompt reviewer "Review the diff." --wait --timeout 120000
herdr agent read reviewer --source recent-unwrapped --lines 120
herdr pane run <pane_id> "just test"
herdr pane wait-output <pane_id> --match "test result" --timeout 120000
```

`herdr --help` lists command groups; run a group bare (`herdr agent`) for its subcommands. Don't run bare `herdr` for discovery — it launches the TUI.

---

## Migration TODO

- Port `dot_config/nvim/lua/overseer/strategy/zellij.lua` to Herdr. The mapping simplifies: `current-tab-info -j` → `herdr pane current --current`; `new-pane -d down` → `herdr pane split --current --direction down --no-focus`; the `write 3` / `write-chars` / `write 13` keystroke dance → one `herdr pane run`; cancel → `herdr pane send-keys <pane> ctrl+c`.
- Pick a date to stop opening Zellij. Two prefix layers with near-identical keys but divergent edge cases is worse than either alone.

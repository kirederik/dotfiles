# jj (Jujutsu)

jj is the primary VCS. It uses git as a backend, so all repos are git-compatible — collaborators using git see normal branches. Repos are typically **colocated** (`jj git init --colocate`), meaning both `.jj/` and `.git/` exist.

## Key concepts

| Concept | Meaning |
|---|---|
| **Working copy is a commit** | Every file change is automatically part of the current change. No staging area. |
| **Change ID** | Stable identifier for a change (survives rewrites). e.g. `swttrztv` |
| **Commit ID** | git SHA — changes on every rewrite. Avoid using these. |
| **`@`** | The current working copy change |
| **`@-`** | Parent of the working copy |
| **Bookmark** | jj's name for a git branch |
| **`tug`** | Custom alias for `jj git fetch` |

---

## git → jj cheatsheet

### Everyday workflow

| git | jj |
|---|---|
| `git status` | `jj status` (`jj st`) |
| `git log --oneline` | `jj log` |
| `git diff` | `jj diff` |
| `git diff HEAD` | `jj diff -r @` |
| `git add -p` | `jj split` (interactive split into two changes) |
| `git commit -m "msg"` | `jj commit -m "msg"` (finalises current change, opens new one) |
| `git commit --amend` | just edit files — working copy auto-amends, or `jj describe` for message only |
| `git stash` | `jj new` (start a new change; old one is preserved) |
| `git stash pop` | `jj squash` (squash working copy into parent) |

### Branches / bookmarks

| git | jj |
|---|---|
| `git branch` | `jj bookmark list` |
| `git checkout -b feat` | `jj bookmark create feat` (stays on current change) |
| `git checkout feat` | `jj edit feat` |
| `git branch -d feat` | `jj bookmark delete feat` |
| `git push -u origin feat` | `jj git push -b feat` |
| `git push --force-with-lease` | `jj git push` (jj handles this automatically) |

### Remote / sync

| git | jj |
|---|---|
| `git fetch` | `jj git fetch` (alias: `jj tug`) |
| `git pull` | `jj git fetch` then `jj rebase -d main@origin` |
| `git push` | `jj git push` |
| `git push --all` | `jj git push --all` (alias: `jj sync`) |
| `git remote add origin url` | `jj git remote add origin url` |
| `git clone url` | `jj git clone url` |

### Rewriting history

| git | jj |
|---|---|
| `git reset HEAD~1` | `jj abandon` (discards current change, keeps files) |
| `git reset --hard` | `jj restore .` |
| `git checkout -- file` | `jj restore file` |
| `git rebase -i` | `jj rebase -r`/`jj squash`/`jj move` — no interactive menu needed |
| `git cherry-pick abc` | `jj duplicate -r abc` then `jj rebase` |
| `git merge branch` | `jj new @ branch` (creates a merge commit) |

---

## Aliases

Defined in `~/.config/jj/config.toml`:

| Alias | Expands to | Purpose |
|---|---|---|
| `jj tug` | `jj git fetch` | Fetch from remote |
| `jj sync` | `jj git push --all` | Push all bookmarks |
| `jj l` | `jj log --limit 10` | Recent log |
| `jj ll` | `jj log` | Full log |
| `jj d` | `jj diff` | Diff |
| `jj s` | `jj status` | Status |
| `jj n` | `jj new` | New change |
| `jj c` | `jj commit` | Commit (finalise + new) |
| `jj sq` | `jj squash` | Squash into parent |
| `jj desc` | `jj describe` | Edit description |
| `jj b` | `jj bookmark` | Bookmark subcommand |
| `jj push` | `jj git push` | Push |

> **Tip:** jj also accepts unambiguous prefix abbreviations without needing aliases:
> `jj st` = status, `jj di` = diff, `jj log` = log, etc.

---

## Typical workflows

### Start new work on a branch

```sh
jj git fetch                    # update remotes
jj new main@origin              # start a change on top of remote main
jj bookmark create feat/my-thing
# ... edit files ...
jj commit -m "feat: my thing"
jj git push -b feat/my-thing
```

### Amend the current change

```sh
# Just edit files — jj auto-amends the working copy commit
jj describe -m "new message"    # change the message only
```

### Fix something in an older change

```sh
jj log                          # find the change ID
jj edit <change-id>             # move working copy to that change
# ... fix files ...
jj new @+                       # go back to where you were
```

### Rebase onto updated main

```sh
jj tug                          # fetch
jj rebase -d main@origin        # rebase working copy branch onto remote main
```

---

## Prompt integration

Starship shows jj info via a custom module (built-in jj module not yet in Homebrew starship):

```
⬡ swttrztv (feat/my-thing) implement new API
```

- `⬡` = jj indicator
- `swttrztv` = short change ID
- `(feat/my-thing)` = bookmark name, shown when present
- Description = first line of commit message
- `∅` = empty change (no diff from parent)
- `✗` = conflict

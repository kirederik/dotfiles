# Git

## Identity switching

Identity is selected automatically based on the repo path — no manual switching needed.

| Path | Name | Email |
|---|---|---|
| `~/dev/github.com/kirederik/**` | kirederik | kirederik@gmail.com |
| `~/dev/github.com/syntasso/**` | Derik Evangelista | derik@syntasso.io |

Always clone via `ghq` to land in the right path:

```sh
ghq get github.com/kirederik/my-project     # personal identity
ghq get github.com/syntasso/kratix          # work identity
```

---

## Conventional Commits

commitlint runs as a **global** git hook on every commit across all repos.

- Config: `~/.commitlintrc.json` (extends `@commitlint/config-conventional`)
- Hook: `~/.config/git/hooks/commit-msg` (set via `core.hooksPath` in `.gitconfig` — no per-repo setup needed)

Format:

```
<type>(optional scope): <subject>

feat: add support for Promise resources
fix(scheduler): handle nil pointer on timeout
docs: update contributing guide
chore: bump golangci-lint to v1.57
```

Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`.

To bypass in an emergency:

```sh
git commit --no-verify -m "wip: temp"
```

---

## git-mob (pair/mob programming)

Co-author config: `~/.git-coauthors` (managed by chezmoi as `dot_git-coauthors`).

```sh
mob cat alice    # start mobbing with cat and alice (syncs git mob + jj)
mob              # end session

git mob --list   # see all configured co-authors
```

The `mob` shell function (in `.zshrc`) wraps `git mob` and keeps jj's co-author config in sync.

Adding a new co-author — edit `dot_git-coauthors` in the repo:

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

Then `chezmoi apply`.

---

## SSH

SSH keys live in Bitwarden — no key files on disk. The Bitwarden desktop app acts as the SSH agent.

`SSH_AUTH_SOCK` is only overridden when the Bitwarden socket exists, so SSH degrades gracefully when the app isn't running.

`~/.ssh/config` sets `ControlMaster auto` globally — repeated connections to the same host (e.g. multiple `git push`) reuse a single SSH session.

Requirements:
- Bitwarden desktop app running
- Settings → SSH Agent → enabled

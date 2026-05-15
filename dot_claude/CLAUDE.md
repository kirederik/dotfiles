## Approach
- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.

## Dotfiles & Config

- When debugging config/tooling issues, always check whether the change belongs in the dotfiles repo (portable across machines) rather than making local-only fixes.
- When installing new tools via brew, include the tool to the respective file in the dotfiles repository (~/.dotfiles)

## Coding

- When the user asks 'why does X not work', explain and diagnose first. Do not jump to proposing fixes or unbinding things until the user confirms they want a change.
- Keep changes minimal and scoped. 
- Do not over-engineer (e.g., creating new scripts when an inline fix suffices) and update ALL call sites when refactoring shared logic.
- After modifying behavior that affects tests (e.g., relationship direction, default values, schemas), proactively check and update related test files (unit, e2e, system tests).

## Debugging

- Before proposing a fix, verify the root cause by reading actual error output or reproducing the issue.
- Do not guess at causes (e.g., architecture mismatches, command identities like 'mc') without evidence.

@RTK.md

#!/usr/bin/env bash
# Install Go tools that aren't available in Homebrew.
# Run manually or via bootstrap.sh.
# Tools managed by the editor (gopls, dlv) are intentionally excluded.
set -euo pipefail

echo "==> Installing Go tools..."

# ─── Formatters ───────────────────────────────────────────────────────────────
go install mvdan.cc/gofumpt@latest                          # stricter gofmt
go install golang.org/x/tools/cmd/goimports@latest          # auto-manage imports
go install github.com/segmentio/golines@latest              # wrap long lines

# ─── Static analysis ──────────────────────────────────────────────────────────
go install honnef.co/go/tools/cmd/staticcheck@latest        # static analysis
go install golang.org/x/vuln/cmd/govulncheck@latest         # vulnerability scanner

# ─── Testing ──────────────────────────────────────────────────────────────────
go install gotest.tools/gotestsum@latest                    # better test output
go install github.com/onsi/ginkgo/v2/ginkgo@latest          # Ginkgo test runner
go install github.com/kyoh86/richgo@latest                  # coloured go test output
go install github.com/mitranim/gow@latest                   # watch + rerun on file change

# ─── Code generation ──────────────────────────────────────────────────────────
go install go.uber.org/mock/mockgen@latest                  # mock generator (uber fork of golang/mock)
go install github.com/google/wire/cmd/wire@latest           # dependency injection
go install github.com/spf13/cobra-cli@latest                # CLI scaffolding
go install github.com/abice/go-enum@latest                  # enum generator
go install github.com/fatih/gomodifytags@latest             # struct tag editor
go install github.com/josharian/impl@latest                 # interface stub generator
go install github.com/cweill/gotests/...@latest             # test scaffolding

# ─── Build / release ──────────────────────────────────────────────────────────
go install github.com/magefile/mage@latest                  # make alternative in Go

# ─── Data / config ────────────────────────────────────────────────────────────
go install github.com/google/go-jsonnet/cmd/jsonnet@latest  # Jsonnet evaluator
go install github.com/brancz/gojsontoyaml@latest            # JSON → YAML (used in Kratix)

echo "==> Go tools installed."

-- User-defined language tooling.
-- LazyVim extras (go, ruby, python, typescript, yaml, json, markdown, docker)
-- are imported in lua/config/lazy.lua — they must precede { import = "plugins" }.
-- This file only contains tools that have no official LazyVim extra.
return {
  -- ── LSP servers ───────────────────────────────────────────────────────────
  -- nvim-lspconfig wires language servers into nvim's LSP client.
  -- Servers listed here are auto-started when you open a matching file.
  -- Mason (below) handles downloading the server binaries.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- html-lsp: completion, hover, and diagnostics for HTML files.
        html = {},
        -- emmet-ls: expands Emmet abbreviations (e.g. div.foo → <div class="foo">)
        -- across HTML, JSX, TSX, and style files.
        emmet_ls = {
          filetypes = { "html", "htmldjango", "javascriptreact", "typescriptreact", "css", "sass", "scss" },
        },
        -- bashls: language server for Bash/shell scripts (hover, diagnostics, rename).
        bashls = {},
      },
    },
  },

  -- ── Mason ─────────────────────────────────────────────────────────────────
  -- Mason is a package manager for LSP servers, linters, and formatters.
  -- ensure_installed guarantees these binaries are present on every machine
  -- after `chezmoi apply` + opening nvim for the first time.
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "html-lsp",            -- HTML language server
        "emmet-ls",            -- Emmet abbreviation expander
        "bash-language-server", -- Bash LSP
        "shellcheck",          -- shell script linter (static analysis)
        "shfmt",               -- shell script formatter
        "markdownlint-cli2",   -- Markdown linter (style + formatting rules)
        "vale",                -- prose linter (grammar, style, tone)
      },
    },
  },

  -- ── neotest-go: Go adapter ────────────────────────────────────────────────
  -- test.core extra (lazy.lua) owns neotest setup and keymaps.
  -- This only registers the Go adapter via opts, which LazyVim merges in.
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-go" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-go")({
        -- Run the whole package when triggered from a Ginkgo spec file.
        -- Ginkgo spec files have no func TestXxx, so neotest-go can't find
        -- individual positions — package-level run picks them all up via
        -- the suite bootstrap in suite_test.go.
        recursive_run = true,
        args = { "-v", "-count=1" },
      }))
    end,
  },

  -- ── Inlay hints: disabled globally (too noisy with := in Go, etc.) ─────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },

  -- ── Pyright: suppress progress notifications ──────────────────────────────
  -- Pyright emits many "Checking..." workspace progress messages that stack up
  -- in the corner. This noice route silently drops them.
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = { event = "lsp", kind = "progress", find = "Pyright" },
          opts = { skip = true },
        },
      },
    },
  },

  -- ── Markdown: disable inline render by default ────────────────────────────
  -- render-markdown.nvim renders headings/code/tables inline by default,
  -- which mixes preview and raw syntax. Disable on open; toggle with <leader>um.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      enabled = false,
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle Markdown Render" },
    },
  },

  -- ── golangci-lint ─────────────────────────────────────────────────────────
  -- golangci-lint runs ~50 Go linters in parallel and surfaces results as
  -- inline diagnostics. It uses the Homebrew binary (already in Brewfile)
  -- rather than a Mason copy, so it stays in sync with your CLI version.
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },
}

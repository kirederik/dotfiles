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
				-- helm-ls: completions and hover for Helm templates, including values
				-- from values.yaml. Only activates on the "helm" filetype (see options.lua).
				helm_ls = {
					settings = {
						["helm-ls"] = {
							yamlls = {
								-- helm-ls embeds yamlls internally for values.yaml and Chart.yaml.
								-- Point it at the Mason-installed binary.
								path = "yaml-language-server",
							},
						},
					},
				},
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
				"html-lsp", -- HTML language server
				"emmet-ls", -- Emmet abbreviation expander
				"bash-language-server", -- Bash LSP
				"shellcheck", -- shell script linter (static analysis)
				"shfmt", -- shell script formatter
				"markdownlint-cli2", -- Markdown linter (style + formatting rules)
				"vale", -- prose linter (grammar, style, tone)
				"helm-ls", -- Helm chart language server
			},
		},
	},

	-- ── Helm: treesitter parser ───────────────────────────────────────────────
	-- Parses mixed YAML/Go-template syntax in Helm chart files.
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "helm" })
		end,
	},

	-- ── neotest: Ginkgo adapter ──────────────────────────────────────────────
	-- LazyVim's lang.go extra already provides neotest-golang for standard Go
	-- tests (func TestXxx). We only add neotest-ginkgo for Ginkgo v2 spec files.
	-- Inserted at position 1 so Ginkgo files are matched before neotest-golang.
	{
		"nvim-neotest/neotest",
		dependencies = { "nvim-contrib/neotest-ginkgo" },
		keys = {
			{
				"<leader>tp",
				function()
					require("neotest").run.run(vim.fn.expand("%:p:h"))
				end,
				desc = "Run package tests",
			},
		},
		opts = function(_, opts)
			opts.adapters = opts.adapters or {}
			table.insert(opts.adapters, 1, require("neotest-ginkgo").setup({
				command = { "ginkgo", "run", "-v" },
			}))
		end,
	},

	-- ── overseer: use Zellij "run" tab when available ─────────────────────────
	{
		"stevearc/overseer.nvim",
		opts = function(_, opts)
			if vim.env.ZELLIJ then
				opts.strategy = { "zellij" }
			end
			return opts
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
			{ "<leader>um", "<cmd>RenderMarkdown toggle<cr>", ft = { "markdown", "mdx" }, desc = "Toggle Markdown Render" },
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
		config = function(_, opts)
			local lint = require("lint")
			-- Extend the default golangci-lint args:
			-- --fast        run only fast linters (skips the slow ones that cause timeouts)
			-- --timeout 30s explicit deadline well under nvim-lint's own timeout
			local golangcilint = lint.linters.golangcilint
			golangcilint.args = vim.list_extend({ "--fast", "--timeout", "30s" }, golangcilint.args or {})
			lint.linters_by_ft = vim.tbl_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft)
		end,
	},
}

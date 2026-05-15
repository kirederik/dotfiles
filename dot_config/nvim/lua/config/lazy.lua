-- Bootstrap lazy.nvim — the plugin manager.
-- If lazy.nvim isn't installed yet, clone it into nvim's data directory.
-- This runs once on a new machine; after that the directory exists and is skipped.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
-- Prepend lazy.nvim to the runtime path so nvim can find it.
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- spec defines the full plugin list. Order matters — LazyVim enforces:
	--   1. lazyvim.plugins (core)  →  2. lazyvim.plugins.extras  →  3. user plugins
	spec = {
		-- 1. LazyVim core: loads the distribution and all its bundled plugins.
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- 2. LazyVim extras: opt-in language packs, each brings an LSP, treesitter
		--    parser, formatter, and linter pre-configured for that language.
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.lang.ruby" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.test.core" },
		{ import = "lazyvim.plugins.extras.editor.overseer" },
		-- 3. User plugins: everything under lua/plugins/ is loaded here.
		--    These can extend or override anything defined above.
		{ import = "plugins" },
	},

	defaults = {
		-- false = user plugins load eagerly at startup (not deferred).
		-- Plugins that define their own event/ft/cmd triggers ignore this anyway.
		lazy = false,
		-- false = always use the latest git commit rather than pinned releases.
		-- Avoids stale tagged releases that can lag behind bug fixes.
		version = false,
	},

	-- Fallback colorschemes used during initial install before your theme loads.
	install = { colorscheme = { "tokyonight", "habamax" } },

	checker = {
		-- Periodically check for plugin updates in the background.
		enabled = true,
		-- Don't show a notification on every update found — check manually with :Lazy.
		notify = false,
	},

	performance = {
		rtp = {
			-- Disable built-in nvim plugins that are never needed in a modern setup,
			-- to shave a few milliseconds off startup time.
			disabled_plugins = {
				"gzip", -- open .gz files (handled by your OS)
				"tarPlugin", -- browse tar archives
				"tohtml", -- convert buffer to HTML
				"tutor", -- the :Tutor command
				"zipPlugin", -- browse zip archives
			},
		},
	},
})

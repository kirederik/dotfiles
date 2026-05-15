-- GitHub Copilot via blink.cmp integration.
-- copilot.lua acts as the backend (auth, LSP connection); suggestions are
-- surfaced inside blink.cmp's popup via blink-cmp-copilot rather than as
-- a separate ghost-text layer — this prevents the two UIs from overlapping.
-- After install, authenticate once with :Copilot auth
return {
  -- Backend: disable built-in suggestion/panel since blink owns the UI.
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = { markdown = true, help = false },
    },
  },

  -- Source adapter: feeds copilot completions into blink.cmp.
  { "giuxtaposition/blink-cmp-copilot" },

  -- Wire the source into blink.cmp and add Ctrl+j to accept.
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<C-j>"] = { "accept", "fallback" },
        ["<CR>"]  = { "fallback" }, -- never accept on Enter; use <C-j> instead
      },
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "Copilot",
            module = "blink-cmp-copilot",
            score_offset = 100, -- float to top of completion list
            async = true,
          },
        },
      },
    },
  },
}

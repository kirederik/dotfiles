-- GitHub Copilot — inline ghost-text suggestions.
-- Uses copilot.lua's native suggestion UI.
-- After install, authenticate once with :Copilot auth
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    -- Explicit keymap via `keys` takes priority over blink.cmp's <C-y> binding.
    -- accept is disabled in opts to prevent the plugin registering its own
    -- lower-priority version of the same key.
    keys = {
      {
        "<Tab>",
        function()
          local s = require("copilot.suggestion")
          if s.is_visible() then s.accept() end
        end,
        mode = "i",
        desc = "Accept Copilot suggestion",
      },
    },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled via keys above; Tab only fires when suggestion is visible
          accept_word = "<C-Right>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },
}

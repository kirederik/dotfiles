-- Catppuccin theme — Mocha flavour to match Ghostty, Zellij, and the rest of the stack.
return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
    },
  },
  -- Tell LazyVim to use Catppuccin as the active colorscheme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

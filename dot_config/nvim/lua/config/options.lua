-- Absolute line numbers (LazyVim enables relativenumber by default)
vim.opt.relativenumber = false

-- Show raw markdown syntax (LazyVim sets conceallevel=2, which hides [text](url)
-- brackets and only reveals them on the cursor line).
vim.opt.conceallevel = 0

-- Indentation (LazyVim defaults to 2 spaces)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Text wrapping
vim.opt.textwidth = 80 -- gw/gq reflows prose to this column
vim.opt.colorcolumn = "81" -- subtle ruler at the wrap boundary

-- Helm filetype detection
-- nvim treats templates/*.yaml as plain YAML; tell it they're Helm so
-- helm-ls activates and yamlls (which chokes on {{ }}) stays silent.
vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.tpl"]  = "helm",
    ["helmfile%.ya?ml"]        = "helm",
  },
})

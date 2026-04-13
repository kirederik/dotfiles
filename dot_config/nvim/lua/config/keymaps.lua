-- <CR> in normal mode: save the current buffer.
-- Note: this shadows <CR> in quickfix/loclist windows — use `o` there instead.
vim.keymap.set("n", "<CR>", "<cmd>w<CR>", { desc = "Save file" })

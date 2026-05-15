-- <CR> in normal mode: save the current buffer.
-- Note: this shadows <CR> in quickfix/loclist windows — use `o` there instead.
vim.keymap.set("n", "<CR>", "<cmd>w<CR>", { desc = "Save file" })

-- Lock Zellij from inside nvim (no-op outside Zellij).
if vim.env.ZELLIJ then
  vim.keymap.set("n", "<leader>zl", "<cmd>silent !zellij action switch-mode locked<CR>", { desc = "Lock Zellij" })
end

-- ── Zellij split-pane runner ──────────────────────────────────────────────────
-- Sends commands to a vertical split in the SAME Zellij tab as the calling nvim.
-- Each tab gets its own run pane (tracked by tab_id), so multiple nvim instances
-- in different tabs each have an independent runner.
--
-- Root cause why write-chars/write need --pane-id: those actions target the
-- keyboard-focused pane (nvim), not whatever tab is currently displayed.

local _run_panes = {}  -- tab_id (string) → pane_id

local function zellij_pane_alive(pane_id)
  vim.fn.system("zellij action dump-screen --pane-id " .. pane_id .. " --path /dev/null 2>/dev/null")
  return vim.v.shell_error == 0
end

local function zellij_get_run_pane()
  -- Get the current tab's ID (the tab where this nvim is running).
  local info = vim.fn.system("zellij action current-tab-info -j 2>/dev/null")
  local tab_id = info:match('"tab_id":%s*(%d+)')
  if not tab_id then return nil end

  local pane_id = _run_panes[tab_id]
  if pane_id and zellij_pane_alive(pane_id) then
    return pane_id
  end

  -- Create a bottom-split zsh pane in this tab; new-pane outputs the pane ID.
  -- Explicit "-- zsh" ensures an interactive login shell that sources .zshrc.
  pane_id = vim.trim(vim.fn.system(
    "zellij action new-pane --tab-id " .. tab_id .. " -d down -- zsh 2>/dev/null"
  ))
  if pane_id == "" then return nil end

  vim.uv.sleep(100)  -- wait for the shell to be ready
  _run_panes[tab_id] = pane_id
  return pane_id
end

local function zellij_run(cmd)
  if not vim.env.ZELLIJ then
    vim.cmd("split | terminal " .. cmd)
    return
  end

  local pane_id = zellij_get_run_pane()
  if not pane_id then
    vim.notify("zellij_run: could not create run pane", vim.log.levels.ERROR)
    return
  end

  vim.fn.system("zellij action write --pane-id " .. pane_id .. " 3 2>/dev/null")  -- Ctrl+C
  vim.uv.sleep(80)
  vim.fn.system("zellij action write-chars --pane-id " .. pane_id .. " " .. vim.fn.shellescape(cmd))
  vim.fn.system("zellij action write --pane-id " .. pane_id .. " 13 2>/dev/null")  -- Enter
end

-- Ginkgo: current package
vim.keymap.set("n", "<leader>tg", function()
  zellij_run("ginkgo -v " .. vim.fn.expand("%:p:h"))
end, { desc = "Ginkgo: run package" })

-- Ginkgo: all packages recursively
vim.keymap.set("n", "<leader>tG", function()
  zellij_run("ginkgo -v -r ./...")
end, { desc = "Ginkgo: run all" })

-- Bats: current file
vim.keymap.set("n", "<leader>tb", function()
  zellij_run("bats " .. vim.fn.expand("%:p"))
end, { desc = "Bats: run file" })

-- Custom command prompt → run pane
vim.keymap.set("n", "<leader>tx", function()
  vim.ui.input({ prompt = "Run: " }, function(input)
    if input and input ~= "" then zellij_run(input) end
  end)
end, { desc = "Run command in Zellij" })

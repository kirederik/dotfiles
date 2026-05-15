-- Overseer strategy: run tasks in a right-split pane in the same Zellij tab
-- as the calling nvim. Each tab gets its own run pane (keyed by tab_id) so
-- multiple nvim instances in different tabs each have an independent runner.
-- Falls back to the built-in terminal strategy when not inside Zellij.

local M = {}
M.__index = M

local _run_panes = {}  -- tab_id (string) → pane_id

local function pane_alive(pane_id)
  vim.fn.system("zellij action dump-screen --pane-id " .. pane_id .. " --path /dev/null 2>/dev/null")
  return vim.v.shell_error == 0
end

local function get_run_pane()
  local info = vim.fn.system("zellij action current-tab-info -j 2>/dev/null")
  local tab_id = info:match('"tab_id":%s*(%d+)')
  if not tab_id then return nil end

  local pane_id = _run_panes[tab_id]
  if pane_id and pane_alive(pane_id) then
    return pane_id
  end

  pane_id = vim.trim(vim.fn.system(
    "zellij action new-pane --tab-id " .. tab_id .. " -d down -- zsh 2>/dev/null"
  ))
  if pane_id == "" then return nil end

  vim.uv.sleep(100)
  _run_panes[tab_id] = pane_id
  return pane_id
end

local function zellij_send(cmd)
  local pane_id = get_run_pane()
  if not pane_id then
    vim.notify("overseer/zellij: could not get run pane", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("zellij action write --pane-id " .. pane_id .. " 3 2>/dev/null")  -- Ctrl+C
  vim.uv.sleep(80)
  vim.fn.system("zellij action write-chars --pane-id " .. pane_id .. " " .. vim.fn.shellescape(cmd))
  vim.fn.system("zellij action write --pane-id " .. pane_id .. " 13 2>/dev/null")  -- Enter
end

function M.new(opts)
  return setmetatable({ opts = opts or {}, _fallback = nil }, M)
end

function M:start(task)
  if not vim.env.ZELLIJ then
    self._fallback = require("overseer.strategy.terminal").new(self.opts)
    self._fallback:start(task)
    return
  end

  local parts = vim.deepcopy(task.cmd)
  if task.args then vim.list_extend(parts, task.args) end
  local cmd = table.concat(vim.tbl_map(function(s)
    return s:find("[%s\"'\\]") and vim.fn.shellescape(s) or s
  end, parts), " ")
  if task.cwd then
    cmd = "cd " .. vim.fn.shellescape(task.cwd) .. " && " .. cmd
  end

  zellij_send(cmd)
end

function M:stop()
  if self._fallback then
    self._fallback:stop()
    return
  end
  if not vim.env.ZELLIJ then return end
  local info = vim.fn.system("zellij action current-tab-info -j 2>/dev/null")
  local tab_id = info:match('"tab_id":%s*(%d+)')
  local pane_id = tab_id and _run_panes[tab_id]
  if pane_id and pane_alive(pane_id) then
    vim.fn.system("zellij action write --pane-id " .. pane_id .. " 3 2>/dev/null")
  end
end

function M:reset()
  if self._fallback then self._fallback:reset() end
end

function M:get_bufnr()
  if self._fallback then return self._fallback:get_bufnr() end
  return nil
end

function M:render(task, lines, highlights, detail)
  if self._fallback then
    self._fallback:render(task, lines, highlights, detail)
  elseif detail > 0 then
    local info = vim.fn.system("zellij action current-tab-info -j 2>/dev/null")
    local tab_id = info:match('"tab_id":%s*(%d+)')
    local pane_id = tab_id and _run_panes[tab_id]
    table.insert(lines, "Running in Zellij pane: " .. (pane_id or "none"))
  end
end

return M

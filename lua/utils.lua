local M = {}
M.general_root = { ".project.*", ".git/", "README.md" }

-- 定义一个函数，用于执行按键序列
function Execute_key_sequence(keys)
  -- 将按键序列传递给 nvim_feedkeys 函数
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

-- 示例：执行一个按键序列，比如 "ggdG"
-- execute_key_sequence("ggdG")

function Close_other_windows()
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_list_wins()

  for _, win in ipairs(wins) do
    if win ~= current_win then
      vim.api.nvim_win_close(win, true)
    end
  end
end

function Close_all()
  if vim.fn.exists(":Neotree") == 2 then
    vim.cmd("Neotree close")
  end

  if vim.fn.exists(":OutlineClose") == 2 then
    vim.cmd("OutlineClose")
  end
  -- vim.api.nvim_command("Neotree close")
  -- vim.api.nvim_command("OutlineClose")
end

return M

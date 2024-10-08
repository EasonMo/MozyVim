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

M.log = function(obj)
  print(vim.inspect(obj))
end

M.find_buffer_by_name = function(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end
  return -1
end

M.find_buffers_by_filetype = function(filetype)
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      if vim.api.nvim_buf_get_option(buf, "filetype") == filetype then
        table.insert(buffers, buf)
      end
    end
  end
  return buffers
end

return M

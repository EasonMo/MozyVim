-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-- 可视化选择搜索
-- map("v", "//", 'y/<c-r>"<cr>', { desc = "Search By Block", noremap = true })
map("v", "//", function()
  local text = vim.getVisualSelection()
  -- 实际上不需要转义
  -- text = text:gsub("/", "\\/")
  -- 修改搜索寄存器
  vim.fn.setreg("/", text)
  vim.cmd('normal! n')
end, { desc = "Search By Block", noremap = true })

local tb = require("telescope.builtin")

map("v", "<space>sb", function()
  local text = vim.getVisualSelection()
  tb.current_buffer_fuzzy_find({ default_text = text })
end, { desc = "selection for buffer", noremap = true, silent = true })

map("v", "<leader>sg", function()
  local text = vim.getVisualSelection()
  tb.live_grep({ default_text = text })
end, { desc = "selection for grep", noremap = true, silent = true })

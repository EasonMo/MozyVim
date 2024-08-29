-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local tb = require("telescope.builtin")
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
  vim.cmd("normal! n")
end, { desc = "Search By Block", noremap = true })

-- 用选中的文本搜索buffer
map("v", "<space>sb", function()
  local text = vim.getVisualSelection()
  tb.current_buffer_fuzzy_find({ default_text = text })
end, { desc = "selection for buffer", noremap = true, silent = true })

-- 用选中的文本grep搜索
map("v", "<leader>sg", function()
  local text = vim.getVisualSelection()
  tb.live_grep({ default_text = text })
end, { desc = "selection for grep", noremap = true, silent = true })

-- 合并行时，不加空格
map({ "n", "x" }, "J", "gJ", { desc = "Join line" })

map({ "n", "x" }, "<C-A>", "ggVG", { desc = "Select All" })

-- 去掉头尾空白行
map("n", "<localleader>ss", function()
  vim.cmd("%s/\\v^\\s+//ge")
  vim.cmd("%s/\\v\\s+$//ge")
  vim.cmd("nohl")
end, { desc = "Strip Whitespace", noremap = true })
-- 合并空格
map("n", "<localleader>sj", function()
  vim.cmd("%s/\\s\\+/ /ge")
  vim.cmd("nohl")
end, { desc = "Join Whitespace", noremap = true })
-- 去掉空格
map("n","<localleader>sd",function()
  vim.cmd("s/\\s//ge")
  vim.cmd("nohl")
end, { desc = "Del Line Whitespace", noremap = true })

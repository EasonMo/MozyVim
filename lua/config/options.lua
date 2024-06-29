-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

------------   基础配置 ------------

-- local set = vim.o
-- local setopt = vim.opt
local set = vim.opt

set.clipboard = "unnamedplus"

-- 缩进配置
set.ts = 4
set.shiftwidth = 4
set.expandtab = true
set.smartindent = false

-- 显示空白字符
-- setopt.list = true
-- setopt.listchars = { space = "·" }

-- setopt.conceallevel = 0
set.backspace = "eol,start,indent"

-- 用自动命令组来设置缩进为2
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  group = vim.api.nvim_create_augroup("filetype_tab_width", { clear = true }),
})

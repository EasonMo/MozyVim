-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

------------   基础配置 ------------

-- local set = vim.o
-- local setopt = vim.opt
local set = vim.opt

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

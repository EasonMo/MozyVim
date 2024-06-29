-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 可视化选择搜索
map("v", "//", 'y/<c-r>"<cr>', { desc = "Search By Block", noremap = true })

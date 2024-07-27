-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-----------------------✂---------------------------
--                 基础配置
-----------------------✂---------------------------

-- 缩进配置
vim.opt.ts = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = false

-- 显示空白字符
-- vim.opt.list = true
-- vim.opt.listchars = { space = "·" }

-- vim.opt.conceallevel = 0
vim.opt.backspace = "eol,start,indent"

-----------------------✂---------------------------
--                LazyVim配置
-----------------------✂---------------------------

-- 取消自动格式化
vim.g.autoformat = false

-----------------------✂---------------------------
--                主题修改
-----------------------✂---------------------------

-- 主题修改要放在options.lua里，否则会因执行顺序而被覆盖
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#292929" })
  end,
})

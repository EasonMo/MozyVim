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

-- 修正linux下的剪贴板
if os.getenv("XDG_CURRENT_DESKTOP") == "GNOME" then
  vim.opt.clipboard = "unnamedplus"
end

-- 添加文件类型, 可设置别名
vim.filetype.add({
  extension = {
    curl = "curl",
    json = "jsonc", -- 解决json注释报错
  },
})

-- 初始化宏
-- 1. 搜索替换: /<C-R>a<CR>viw"bp
vim.fn.setreg("m", "\x2f\x80\xfc\x04\x52\x61\x0d\x76\x69\x77\x22\x62\x70")
-- 2. 粘贴："0p
vim.fn.setreg("p", "\x22\x30\x70")
-- 3. 整词粘贴：viw"0p
vim.fn.setreg("o", "\x76\x69\x77\x22\x30\x70")

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

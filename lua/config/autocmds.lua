-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-----------------------✂---------------------------
--                  自动命令
-----------------------✂---------------------------

-- 设置缩进为2
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "lua", "json", "jsonc", "markdown", "vue" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  group = vim.api.nvim_create_augroup("filetype_tab_width", { clear = true }),
})

-- 禁止拼写检查
-- 获取filetype: echo &filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
  end,
  group = vim.api.nvim_create_augroup("filetype_spell_check", { clear = true }),
})

-- close some filetypes with <q>，补充缺失的
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "dap-float",
    "lazy_backdrop",
    "crunner",
    "vim", -- 历史命令窗口
    "gitsigns-blame",
    "query",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    -- vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    vim.keymap.set("n", "q", function()
      -- 关闭code_runner运行窗口
      local current_buf = vim.fn.bufname("%")
      if string.find(current_buf, "crunner_") then
        return "<cmd>RunClose<cr>"
      end
      return "<cmd>close<cr>"
    end, { buffer = event.buf, silent = true, expr = true })
  end,
})

-- 实现复制时与系统剪贴板同步，支持tmux，ssh，排除gnome环境
if os.getenv("XDG_CURRENT_DESKTOP") ~= "GNOME" and vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52", -- name不能修改，否则ssh下iterm2会弹剪贴板访问的警告
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = { "*" },
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setreg("+", vim.fn.getreg("0"))
    end
  end,
  group = vim.api.nvim_create_augroup("YankToClipboard", { clear = true }),
})

-- 动态关闭smartcase：优化Cmdline补全
vim.api.nvim_create_augroup("dynamic_smartcase", { clear = true })
vim.api.nvim_create_autocmd("CmdLineEnter", {
  group = "dynamic_smartcase",
  callback = function()
    vim.opt.smartcase = false
  end,
})
vim.api.nvim_create_autocmd("CmdLineLeave", {
  group = "dynamic_smartcase",
  callback = function()
    -- smartcase为true时，有大写则case-sensitive
    vim.opt.smartcase = true
  end,
})

-----------------------✂---------------------------
--                 自定义命令
-----------------------✂---------------------------

-- 获取浮窗类型
vim.api.nvim_create_user_command("GetWinType", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      -- print(vim.api.nvim_get_option_value(vim.api.nvim_win_get_buf(win), "filetype"))
      print(vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win) }))
    end
  end
end, { desc = "Print float windows filetype" })

-- 代码处理
vim.api.nvim_create_user_command("ReplaceRequireToImport", function()
  vim.cmd([[
    %s/const \(.*\) = require(\(.*\))/import \1 from \2/g
  ]])
end, { nargs = 0, desc = "Replace require to import" })

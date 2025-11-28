-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-----------------------✂---------------------------
--                  自动命令
-----------------------✂---------------------------

-- 设置缩进为2
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("filetype_tab_width", { clear = true }),
  pattern = { "sh", "lua", "json", "jsonc", "markdown", "vue" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- 禁止拼写检查
-- 获取filetype: echo &filetype
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("filetype_spell_check", { clear = true }),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
  end,
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
  group = vim.api.nvim_create_augroup("YankToClipboard", { clear = true }),
  pattern = { "*" },
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setreg("+", vim.fn.getreg("0"))
    end
  end,
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

-- 设置curl文件的属性
vim.api.nvim_create_autocmd("FileType", {
  pattern = "curl",
  callback = function()
    -- stylua: ignore start
    vim.bo.shiftwidth = 2   -- 自动缩进宽度
    vim.bo.tabstop = 2      -- Tab 显示宽度
    vim.bo.expandtab = true -- 用空格代替 Tab
  end,
})

-- 修改vim-dadbod-ui默认设置
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    -- 用treesitter处理vim-dadbod-ui的query
    vim.bo.filetype = "sql"
    vim.keymap.del("i", "<left>", { buffer = true })
    vim.keymap.del("i", "<right>", { buffer = true })
  end,
})

-- 新建tab页时，删除多余的空白页
vim.api.nvim_create_autocmd("TabNewEntered", {
  group = vim.api.nvim_create_augroup("CloseNoNameOnTabNew", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.bo[buf].buftype

    if name ~= "" and buftype ~= "" then
      return
    end

    -- 参考Snacks.bufdelete()
    ---@diagnostic disable: param-type-mismatch
    vim.api.nvim_buf_call(buf, function()
      local fallback = false
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
          if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
            return
          end

          -- Try using alternate buffer
          local alt = vim.fn.bufnr("#")
          if alt ~= buf and vim.fn.buflisted(alt) == 1 then
            vim.api.nvim_win_set_buf(win, alt)
            return
          end

          -- Try using previous buffer
          -- 此处能处理gitsigns在新tab页打开的情况：因为commit_buf在tabnew之前创建
          local has_previous = pcall(vim.cmd, "bprevious")
          if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
            return
          end

          -- 回滚到默认行为：不删除buffer
          fallback = true
        end)
      end
      if not fallback and vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "bdelete! " .. buf)
      end
    end)
  end,
})

-----------------------✂---------------------------
--                 自定义命令
-----------------------✂---------------------------

-- 获取浮窗类型
vim.api.nvim_create_user_command("GetFloatWinType", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      print(vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win) }))
    end
  end
end, { desc = "Print float windows filetype" })

-- 代码处理
vim.api.nvim_create_user_command("JSReplaceRequireToImport", function()
  vim.cmd([[
    %s/const \(.*\) = require(\(.*\))/import \1 from \2/g
  ]])
end, { nargs = 0, desc = "Replace require to import for javaScript" })

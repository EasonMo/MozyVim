-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local expand = vim.fn.expand
local function getVisualSelection()
  vim.cmd('noau normal! "vy')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-- 新建tab页，并删除空白页，主要用来调试看代码
map("n", "<leader><tab><tab>", function()
  vim.cmd("tabnew")
  Snacks.bufdelete()
end, { desc = "New Tab" })

-- 复制文件名
map("n", "<leader>fy", function()
  local exclusive_filetype = {
    "lazy",
    "lazy_backdrop",
    "crunner",
    "dap-float",
    "dap-repl",
    "dapui_console",
    "gitsigns-blame",
    "mason",
    "neo-tree",
    "Outline",
    "snacks_terminal",
    "vim", -- 历史命令窗口
    "query",
  }
  if vim.tbl_contains(exclusive_filetype, vim.bo.filetype) then
    Snacks.notify.warn("not supported filetype", { title = "FilePath Copy Selector" })
    return
  end
  require("util").file_name_copy_selector(expand("%:t"), expand("%:p"))
end, { desc = "Copy File Name" })

-- 设置文件类型
map("n", "<leader>ft", function()
  -- 覆盖LazyVim的Terminal (Root Dir)快捷键，原<leader>ft改成<leader>fT
  -- stylua: ignore
  local options = {
    { label = "python",         ft = "python",      order = 1 },
    { label = "shell script",   ft = "sh",          order = 2 },
    { label = "javaScript",     ft = "javascript",  order = 3 },
    { label = "lua",            ft = "lua",         order = 4 },
    { label = "go",             ft = "go",          order = 5 },
    { label = "other",          ft = nil,           order = 99 },
  }
  table.sort(options, function(a, b)
    return a.order < b.order
  end)
  vim.ui.select(options, {
    prompt = "Choose file type to set:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    local ft = choice.ft or vim.fn.input({ prompt = "Enter file type: ", completion = "filetype" })
    if ft == "" then
      return
    end
    vim.cmd("silent! LspStop")
    vim.bo.filetype = ft
    vim.notify("set filetype=" .. ft)
  end)
end, { desc = "Set File Type" })

-- 可视化选择搜索
-- map("v", "//", 'y/<c-r>"<cr>', { desc = "Search By Block", noremap = true })
map("v", "//", function()
  local text = getVisualSelection()
  -- 实际上不需要转义
  -- text = text:gsub("/", "\\/")
  -- 修改搜索寄存器
  vim.fn.setreg("/", text)
  vim.cmd("normal! n")
end, { desc = "Search By Block", noremap = true })

-- 合并行时，不加空格
map({ "n", "x" }, "J", "gJ", { desc = "Join line" })

-- 全选，跟增加数字冲突，很少使用
-- map({ "n", "x" }, "<C-A>", "ggVG", { desc = "Select All" })

-- 去掉行尾空白
map("n", "<localleader>st", function()
  vim.cmd("%s/\\v\\s+$//ge")
  vim.cmd("nohl")
end, { desc = "Trail Whitespace", noremap = true })
-- 去掉头尾空白
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
map("n", "<localleader>sl", function()
  vim.cmd("s/\\s\\+/ /ge")
  vim.cmd("nohl")
end, { desc = "Join Line Whitespace", noremap = true })
-- 去掉空格
map("n", "<localleader>sd", function()
  vim.cmd("s/\\s//ge")
  vim.cmd("nohl")
end, { desc = "Del Line Whitespace", noremap = true })

-- 高亮显示所标记的两行的最大相同部分
map("n", "<localleader>l", function()
  -- 获取标记处的文本
  local function get_line(bufnr, mark)
    local row, _ = unpack(vim.api.nvim_buf_get_mark(bufnr, mark))
    -- 获取当前缓冲区中指定行的文本
    local lines = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)
    return lines[1]
  end

  -- 求两个字符串的最长公共子串
  local function longest_common_substring(str1, str2)
    local len1 = #str1
    local len2 = #str2
    local max_len = 0
    local ending_index = 0
    local matrix = {}

    -- 初始化矩阵
    for i = 0, len1 do
      matrix[i] = {}
      for j = 0, len2 do
        matrix[i][j] = 0
      end
    end

    -- 动态规划计算最长公共子串
    for i = 1, len1 do
      for j = 1, len2 do
        if str1:sub(i, i) == str2:sub(j, j) then
          matrix[i][j] = matrix[i - 1][j - 1] + 1
          if matrix[i][j] > max_len then
            max_len = matrix[i][j]
            ending_index = i
          end
        end
      end
    end

    -- 返回最长公共子串
    if max_len > 0 then
      return str1:sub(ending_index - max_len + 1, ending_index)
    else
      return ""
    end
  end

  -- 获取当前缓冲区号
  local bufnr = vim.api.nvim_get_current_buf()
  -- 获取两行文本
  local text1 = get_line(bufnr, "a")
  local text2 = get_line(bufnr, "b")
  if text1 == nil or text2 == nil then
    vim.notify("高亮公共子串前，请先标记行")
    return
  end
  -- 计算并输出最长公共子串
  local lcs = longest_common_substring(text1, text2)
  lcs = string.gsub(lcs, "]", "\\]")
  -- 高亮公共子串
  vim.fn.setreg("/", lcs)
  vim.cmd("normal! n")
end, { desc = "Longest Common Substring", noremap = true })

-- stylua: ignore start

-- 在当前工作目录下打开terminal
-- 在tmux下，ctrl-/、ctrl--、ctrl-_等价，都是^_
map("n", "<c-/>", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<c-_>", function() Snacks.terminal() end, { desc = "which_key_ignore" })
map("n", "<leader>fT", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" }) -- 原是Terminal (cwd)
map("n", "<localleader>dd", "<cmd>diffthis<cr>", { desc = "diff this" })
map("n", "<localleader>do", "<cmd>diffoff!<cr>", { desc = "diff off!" })
map("n", "<leader>m", "<cmd>messages<cr>", { desc = "Messages" })
map("n", "<leader>snc", "<cmd>messages clear<cr>", { desc = "Clear Messages" })
map("n", "<leader>qu", "<cmd>q!<cr>", { desc = "Quit without Writing" })

-- 切换paste模式: CMD+V时不会乱缩进
Snacks.toggle.option("paste", { name = "Paste Mode" }):map("<leader>uP")

-- stylua: ignore end

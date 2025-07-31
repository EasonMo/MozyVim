return {
  -- buffer栏
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = { -- NOTE: 需要同步LazyVim的配置, LazyVim/lua/lazyvim/plugins/ui.lua
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "BufferLineOffsetText", -- 初始值是"Directory"
            text_align = "left",
            separator = true,
          },
          {
            filetype = "snacks_layout_box",
            separator = true,
          },
          {
            filetype = "dapui_scopes",
            text = "DAP",
            highlight = "BufferLineOffsetTextLight",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
    keys = {
      { "<leader>bs", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
    },
  },
  -- lualine, 修改状态栏
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_y = {
        "progress",
      }
      opts.sections.lualine_z = {
        "location",
      }
    end,
  },
  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<C-n>", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    opts = {
      close_if_last_window = true,
      -- 配置弹窗的属性
      popup_border_style = "rounded",
      filesystem = {
        filtered_items = {
          -- visible = false, -- when true, they will just be displayed differently than normal items
          -- hide_dotfiles = true,
          hide_gitignored = false,
          -- hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            -- ".DS_Store",
            -- "thumbs.db",
            "node_modules",
            "LICENSE",
          },
          hide_by_pattern = {
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          always_show_by_pattern = { -- uses glob style patterns
            --".env*",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            ".DS_Store",
            "thumbs.db",
            "__pycache__",
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
      },
      commands = {
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name

          require("utils").file_name_copy_selector(filename, filepath)
        end,
      },
      window = {
        mappings = {
          Y = "copy_selector",
        },
      },
    },
  },
  -- 大纲导航
  {
    "hedyhli/outline.nvim",
    opts = {
      outline_window = {
        width = 20,
      },
    },
  },
  -- vscode, 主题
  {
    "mofiqul/vscode.nvim",
    config = function()
      -- 颜色值采用P3色彩空间
      -- 参考颜色：
      --   "#8f8f8f"

      vim.o.background = "dark"
      local editerBg = "#1F1F1F" -- 代码编辑区的颜色
      local editerBgNC = "#1C1C1C" -- 窗口非当前选择时
      local bufferBg = "#171717" -- buffer栏的颜色, vscode的值是"#181818", 调更黑一点
      -- local bufferSeparator = "#2B2B2B"
      local bufferlineDiagnostic = "#5a5a5a"
      local floatBg = "#1a1a1a"

      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        italic_comments = true,

        -- Disable nvim-tree background color
        -- disable_nvimtree_bg = true,

        -- Override colors (see ./lua/vscode/colors.lua)
        color_overrides = {
          -- vscLineNumber = "#FFFFFF",
        },

        -- Override highlight groups (see ./lua/vscode/theme.lua)
        ---@type table<string, vim.api.keyset.highlight>
        group_overrides = {
          -- 查询光标处的 Highlight 信息：:Inspect或:lua print(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))

          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!

          -- nvim内置

          -- 定义光标颜色：
          --   1. iTerm2 v3.4不起作用，需要在iTerm2的Profiles中将Cursor Text设为 10% Gray
          --   2. 添加配置:
          --     vim.opt.guicursor = "n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"
          --   3. 查看帮助:
          --     :h guicursor
          -- Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          CursorLine = { bg = "#292929" },
          IndentHighlight = { fg = "#313131" },
          -- 修正弹窗的颜色不一致，如行号、标题
          LineNr = { fg = c.vscLineNumber },
          CursorLineNr = { fg = "#bbbbbb" },
          FloatTitle = { link = "NormalFloat" },
          -- 修复lualine中trouble面包屑空格的背景颜色不一致
          StatusLine = { link = "lualine_c_normal" },
          NormalFloat = { bg = floatBg }, -- 使用的地方: hover, terminal
          SnacksWinBar = { bold = true, bg = floatBg }, -- terminal的标题栏, 来源: snacks.nvim/lua/snacks/win.lua

          -- 代码高亮：
          -- lua: 区分vim，table等内置类型和模块
          -- ["@variable.builtin"] = { fg = c.vscBlueGreen },
          -- ["@module.builtin"] = { link = "@variable.builtin" },
          -- ["@namespace.builtin"] = { link = "@variable.builtin" },
          ["@lsp.type.variable"] = {}, -- Semantic Tokens 优先级比 treesitter 高，置空可让treesitter生效
          -- ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
          -- ["@lsp.type.selfTypeKeyword"] = { link = "@variable.builtin" },
          -- ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
          -- ["@lsp.typemod.variable.global"] = { link = "@variable.builtin" },

          -- blink
          BlinkCmpMenu = { bg = floatBg, fg = "#bbbbbb" },
          BlinkCmpDoc = { bg = floatBg, fg = "#bbbbbb" },
          BlinkCmpDocBorder = { bg = floatBg },
          BlinkCmpMenuSelection = { bg = c.vscPopupHighlightBlue },
          BlinkCmpDocSeparator = { bg = floatBg },
          BlinkCmpSignatureHelp = { bg = floatBg },

          -- bufferLine
          -- BufferLineFill = { bg = bufferBg }, -- 空白条填充
          BufferLineIndicatorSelected = { bg = editerBg, fg = "#0070D7" },
          BufferLineBuffer = { bg = bufferBg, fg = c.vscGray },
          BufferLineBackground = { bg = bufferBg, fg = c.vscGray },
          BufferLineNumbers = { bg = bufferBg, fg = c.vscGray },
          BufferLineCloseButton = { bg = bufferBg, fg = c.vscGray },
          BufferLineTabClose = { bg = bufferBg, fg = c.vscGray },
          BufferLineGroupSeparator = { bg = "#111111", fg = c.vscGray },
          BufferLineTruncMarker = { bg = "#141414", fg = c.vscGray },
          BufferLineWarning = { bg = bufferBg, fg = c.vscGray, sp = "#dcdcaa" },
          BufferLineError = { bg = bufferBg, fg = c.vscGray, sp = "#f44747" },
          BufferLineInfo = { bg = bufferBg, fg = c.vscGray, sp = c.vscBlue },
          BufferLineHint = { bg = bufferBg, fg = c.vscGray, sp = c.vscBlue },
          BufferLineTab = { bg = bufferBg, fg = c.vscGray },
          BufferLineTabSelected = { bg = editerBg, fg = "#82AAFF" },
          BufferLineDuplicate = { bg = bufferBg, fg = c.vscGray },
          BufferLineDuplicateSelected = { bg = editerBgNC, fg = c.vscGray },

          -- 区分非选中时切换的颜色变化，如在buffer和neotree之间切换bufferline标签颜色变化
          BufferLineBufferVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineCloseButtonVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineDuplicateVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineErrorVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineHintVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineInfoVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineNumbersVisible = { bg = editerBgNC, fg = c.vscGray },
          BufferLineWarningVisible = { bg = editerBgNC, fg = c.vscGray },
          -- 非选中下，语法检查标记要比vscGray稍暗一点
          BufferLineDiagnostic = { bg = bufferBg, fg = bufferlineDiagnostic },
          BufferLineDiagnosticVisible = { bg = editerBgNC, fg = bufferlineDiagnostic },
          BufferLineHintDiagnostic = { bg = bufferBg, fg = bufferlineDiagnostic, sp = "#4075a0" },
          BufferLineHintDiagnosticVisible = { bg = editerBgNC, fg = bufferlineDiagnostic },
          BufferLineInfoDiagnostic = { bg = bufferBg, fg = bufferlineDiagnostic, sp = "#4075a0" },
          BufferLineInfoDiagnosticVisible = { bg = editerBgNC, fg = bufferlineDiagnostic },
          BufferLineErrorDiagnostic = { bg = bufferBg, fg = bufferlineDiagnostic, sp = "#b73535" },
          BufferLineErrorDiagnosticVisible = { bg = editerBgNC, fg = bufferlineDiagnostic },
          BufferLineWarningDiagnostic = { bg = bufferBg, fg = bufferlineDiagnostic, sp = "#a5a57f" },
          BufferLineWarningDiagnosticVisible = { bg = editerBgNC, fg = bufferlineDiagnostic },

          BufferLineSeparator = { bg = bufferBg, fg = "#313131" }, -- fg与左侧neotree分隔线一致
          BufferLineOffsetText = { bg = bufferBg, fg = c.vscBlue, bold = true }, -- 左侧顶部标题栏的颜色
          BufferLineOffsetTextLight = { bg = editerBg, fg = c.vscBlue, bold = true }, -- 浅色
          BufferLineOffsetSeparator = { bg = editerBg, fg = "#444444" }, -- 改默认值的bg
          BufferLineTabSeparator = { bg = bufferBg, fg = "#313131" },
          BufferLineTabSeparatorSelected = { bg = editerBg, fg = editerBg },
          -- flash搜索时，背景变灰色
          FlashBackdrop = { fg = c.vscGray },
          -- lazygit, 在此定义highlight，在snacks.nvim中配置
          LazyGitActiveBorderColor = { fg = c.vscBlueGreen },
          LazyGitInactiveBorderColor = { fg = c.vscGray },
          LazyGitSearchingActiveBorderColor = { fg = c.vscBlueGreen },
          -- neo-tree
          NeoTreeNormal = { bg = bufferBg },
          NeoTreeNormalNC = { bg = bufferBg },
          NeoTreeRootName = { fg = "#cccccc" },
          NeoTreeDirectoryName = { fg = "#cccccc" },
          NeoTreeFileName = { fg = "#cccccc" },
          NeoTreeCursorLine = { bg = "#212121" }, -- 深色背景，光标要更暗一点
          NeoTreeIndentMarker = { fg = "#5a5a5a" },
          NeoTreeExpander = { fg = "#a0a0a0" },
          NeoTreeDimText = { bg = bufferBg }, -- filter的标题
          -- dashboard配置，参考: lua/tokyonight/groups/snacks.lua, extras/helix/tokyonight_night.toml
          SnacksDashboardDesc = { fg = "#7dcfff" },
          SnacksDashboardHeader = { fg = "#7aa2f7" },
          SnacksDashboardFooter = { fg = "#2ac3de" },
          SnacksDashboardIcon = { fg = "#2ac3de" },
          SnacksDashboardKey = { fg = "#ff9e64" },
          SnacksDashboardSpecial = { fg = "#9d7cd8" },
          -- snacks-picker
          SnacksPickerListCursorLine = { bg = c.vscPopupHighlightBlue },
          SnacksPickerDir = { fg = c.vscLineNumber },
          SnacksPickerBorder = { link = "WinSeparator" },
          SnacksPickerTitle = { bg = editerBg },
          SnacksPickerDimmed = { fg = c.vscFront },
          -- trouble
          TroubleCount = { fg = c.vscFront },
          TroubleFilename = { fg = c.vscBlue },
          TroubleDirectory = { fg = c.vscBlue },
          -- which-key
          WhichKeyBorder = { bg = floatBg, fg = c.vscGray },
        },
      })
    end,
  },
  -- 指定要使用的主题
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = { "vscode" },
    },
  },
  { "catppuccin", enabled = false },
  -- noice
  {
    "folke/noice.nvim",
    keys = {
      -- stylua: ignore
      -- 弹窗执行命令行的命令，同shift+回车, 按Esc跳至弹窗
      { "<A-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline", },
    },
  },
  -- 彩虹括号
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    main = "rainbow-delimiters.setup",
    submodules = false,
  },
  -- tmux窗口切换
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- 按键提示
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>s", group = "search/noice" },
        { "<leader>r", group = "+refactor/runner", mode = { "n", "v" } },
        { "<localleader>s", group = "Strip Whitespace", mode = "n" },
        { "<localleader>d", group = "Diff", mode = "n" },
        { "<localleader>r", group = "Replace", mode = "n" },
      },
    },
  },
  -- 文本高亮
  {
    "Mr-LLLLL/interestingwords.nvim",
    event = "VeryLazy",
    opts = {
      colors = { "#8CCBEA", "#A4E57E", "#FFDB72", "#FF7272", "#FFB3FF", "#9999FF", "#0087ff", "#b88823", "#FF00E7" },
      search_count = false,
      navigation = false,
      search_key = "<localleader>m",
      cancel_search_key = "<localleader>M",
      color_key = "<localleader>k",
      cancel_color_key = "<localleader>K",
      select_mode = "random",
      -- select_mode = "loop",
    },
    config = function(_, opts)
      require("interestingwords").setup(opts)
    end,
  },
  -- snacks
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    },
    ---@type snacks.Config
    opts = {
      bigfile = {
        notify = false,
      },
      -- logo
      dashboard = {
        preset = {
          header = [[
          ███╗   ███╗ ██████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          ████╗ ████║██╔═══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
          ██╔████╔██║██║   ██║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
          ██║╚██╔╝██║██║   ██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ██║ ╚═╝ ██║╚██████╔╝███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚═╝     ╚═╝ ╚═════╝ ╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
          ]],
        },
      },
      -- 缩进线
      indent = {
        indent = {
          char = "╎",
          hl = "IndentHighlight",
        },
      },
      lazygit = {
        ---@diagnostic disable-next-line: missing-fields
        theme = {
          activeBorderColor = { fg = "LazyGitActiveBorderColor", bold = true },
          inactiveBorderColor = { fg = "LazyGitInactiveBorderColor" },
          searchingActiveBorderColor = { fg = "LazyGitSearchingActiveBorderColor", bold = true },
        },
      },
      scratch = {
        filekey = {
          branch = false,
        },
        ---@diagnostic disable-next-line: missing-fields
        win = {
          wo = { winhighlight = "NormalFloat:Normal,FloatBorder:WinSeparator" },
        },
      },
      -- 取消平滑滚动，影响：查找引用时的picker首个结果的行数定位，搜索次数显示
      scroll = { enabled = false },
    },
  },
  -- nvim-window-picker
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    keys = {
      {
        "<leader>wp",
        function()
          print("win_id: " .. (require("window-picker").pick_window() or "not pick"))
        end,
        desc = "Window Picker",
      },
    },
    opts = {
      hint = "floating-big-letter",
      show_prompt = false,
      filter_rules = {
        include_current_win = true,
      },
    },
  },
  -- treesitter playground
  {
    "nvim-treesitter/playground",
    lazy = true,
    cmd = { "TSHighlightCapturesUnderCursor", "TSNodeUnderCursor" },
  },
  -- persistence.nvim
  {
    "folke/persistence.nvim",
    keys = {
      {
        "<leader>qd",
        function()
          local persistence = require("persistence")
          persistence.stop()
          local file_name = persistence.current()
          if require("utils").file_exists(file_name) then
            os.execute("rm " .. file_name)
          end
          vim.cmd("qa")
        end,
        desc = "Quit without save Session",
      },
    },
  },
}

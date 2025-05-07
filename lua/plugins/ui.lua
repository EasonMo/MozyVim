return {
  -- buffer栏
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = { -- NOTE: 需要同步LazyVim的配置, LazyVim/lua/lazyvim/plugins/ui.lua
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "NeoTreeTopTitle", -- 初始值是"Directory"
            text_align = "left",
            separator = true,
          },
          {
            filetype = "snacks_layout_box",
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
      local editerBg = "#1F1F1F"
      local bufferBg = "#171717" -- vscode的值是"#181818", 调更黑一点
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
        group_overrides = {
          -- 查询光标处的 Highlight 信息：:Inspect或:lua print(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))

          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!

          -- nvim内置
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
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
          -- ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
          -- ["@lsp.type.selfTypeKeyword"] = { link = "@variable.builtin" },
          -- ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
          -- ["@lsp.typemod.variable.global"] = { link = "@variable.builtin" },

          -- blink
          BlinkCmpMenu = { fg = "#bbbbbb", bg = floatBg },
          BlinkCmpDoc = { fg = "#bbbbbb", bg = floatBg },
          BlinkCmpDocBorder = { bg = floatBg },
          BlinkCmpMenuSelection = { bg = c.vscPopupHighlightBlue },
          BlinkCmpDocSeparator = { bg = floatBg },
          BlinkCmpSignatureHelp = { bg = floatBg },

          -- bufferLine
          -- BufferLineFill = { bg = bufferBg }, -- 空白条填充
          BufferLineIndicatorSelected = { fg = "#0070D7", bg = editerBg },

          BufferLineBuffer = { fg = c.vscGray, bg = bufferBg },
          BufferLineWarningVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineBackground = { fg = c.vscGray, bg = bufferBg },
          BufferLineInfoVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineHintVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineNumbersVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineNumbers = { fg = c.vscGray, bg = bufferBg },
          BufferLineBufferVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineCloseButtonVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineCloseButton = { fg = c.vscGray, bg = bufferBg },
          BufferLineTabClose = { fg = c.vscGray, bg = bufferBg },
          BufferLineGroupSeparator = { fg = c.vscGray, bg = "#111111" },
          BufferLineTruncMarker = { fg = c.vscGray, bg = "#141414" },
          BufferLineWarning = { fg = c.vscGray, bg = bufferBg, sp = "#dcdcaa" },
          BufferLineError = { fg = c.vscGray, bg = bufferBg, sp = "#f44747" },
          BufferLineInfo = { fg = c.vscGray, bg = bufferBg, sp = "#569cd6" },
          BufferLineHint = { fg = c.vscGray, bg = bufferBg, sp = "#569cd6" },
          BufferLineTab = { fg = c.vscGray, bg = bufferBg },
          BufferLineErrorVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineTabSelected = { fg = "#82AAFF" },
          BufferLineDuplicate = { fg = c.vscGray, bg = bufferBg },
          BufferLineDuplicateVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineDuplicateSelected = { fg = c.vscGray, bg = "#1c1c1c" },

          -- 非选中下，语法检查标记要比vscGray稍暗一点
          BufferLineWarningDiagnosticVisible = { fg = bufferlineDiagnostic, bg = "#1c1c1c" },
          BufferLineWarningDiagnostic = { fg = bufferlineDiagnostic, bg = bufferBg, sp = "#a5a57f" },
          BufferLineInfoDiagnostic = { fg = bufferlineDiagnostic, bg = bufferBg, sp = "#4075a0" },
          BufferLineHintDiagnosticVisible = { fg = bufferlineDiagnostic, bg = "#1c1c1c" },
          BufferLineHintDiagnostic = { fg = bufferlineDiagnostic, bg = bufferBg, sp = "#4075a0" },
          BufferLineDiagnosticVisible = { fg = bufferlineDiagnostic, bg = "#1c1c1c" },
          BufferLineErrorDiagnostic = { fg = bufferlineDiagnostic, bg = bufferBg, sp = "#b73535" },
          BufferLineInfoDiagnosticVisible = { fg = bufferlineDiagnostic, bg = "#1c1c1c" },
          BufferLineDiagnostic = { fg = bufferlineDiagnostic, bg = bufferBg },
          BufferLineErrorDiagnosticVisible = { fg = bufferlineDiagnostic, bg = "#1c1c1c" },

          BufferLineSeparator = { bg = bufferBg, fg = "#313131" },
          BufferLineOffsetSeparator = { bg = editerBg, fg = "#444444" },
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
          NeoTreeRootName = { fg = "#cccccc", bg = bufferBg },
          NeoTreeDirectoryName = { fg = "#cccccc", bg = bufferBg },
          NeoTreeFileName = { fg = "#cccccc", bg = bufferBg },
          NeoTreeTopTitle = { bg = bufferBg, fg = c.vscBlue, bold = true }, -- 标题栏的颜色，bufferline控制
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
          SnacksPickerTitle = { bg = "#1F1F1F" },
          -- which-key
          WhichKeyBorder = { fg = c.vscGray, bg = floatBg },
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
    },
  },
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
}

return {
  -- buffer栏
  {
    "akinsho/bufferline.nvim",
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
      -- 注：
      --   1. hover使用NormalFloat

      vim.o.background = "dark"
      -- local vscode_editer_bg = "#1F1F1F"
      -- local vscode_buffer_bg = "#181818"
      -- local vscode_buffer_separator = "#2B2B2B"
      local bufferLine_diagnostic = "#5a5a5a"

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
          NormalFloat = { bg = "#1a1a1a" },

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
          BlinkCmpMenu = { fg = "#bbbbbb", bg = "#1a1a1a" },
          BlinkCmpDoc = { fg = "#bbbbbb", bg = "#1a1a1a" },
          BlinkCmpDocBorder = { bg = "#1a1a1a" },
          BlinkCmpMenuSelection = { bg = c.vscPopupHighlightBlue },
          BlinkCmpDocSeparator = { bg = "#1a1a1a" },
          BlinkCmpSignatureHelp = { bg = "#1a1a1a" },

          -- bufferLine
          BufferLineIndicatorSelected = { fg = "#0070D7", bg = "#1F1F1F" },

          BufferLineBuffer = { fg = c.vscGray, bg = "#171717" },
          BufferLineWarningVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineBackground = { fg = c.vscGray, bg = "#171717" },
          BufferLineInfoVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineHintVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineNumbersVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineNumbers = { fg = c.vscGray, bg = "#171717" },
          BufferLineBufferVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineCloseButtonVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineCloseButton = { fg = c.vscGray, bg = "#171717" },
          BufferLineTabClose = { fg = c.vscGray, bg = "#171717" },
          BufferLineGroupSeparator = { fg = c.vscGray, bg = "#111111" },
          BufferLineTruncMarker = { fg = c.vscGray, bg = "#111111" },
          BufferLineWarning = { fg = c.vscGray, bg = "#171717", sp = "#dcdcaa" },
          BufferLineError = { fg = c.vscGray, bg = "#171717", sp = "#f44747" },
          BufferLineInfo = { fg = c.vscGray, bg = "#171717", sp = "#569cd6" },
          BufferLineHint = { fg = c.vscGray, bg = "#171717", sp = "#569cd6" },
          BufferLineTab = { fg = c.vscGray, bg = "#171717" },
          BufferLineErrorVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineTabSelected = { fg = "#82AAFF" },
          BufferLineDuplicate = { fg = c.vscGray, bg = "#171717" },
          BufferLineDuplicateVisible = { fg = c.vscGray, bg = "#1c1c1c" },
          BufferLineDuplicateSelected = { fg = c.vscGray, bg = "#1c1c1c" },

          -- 非选中下，语法检查标记要比vscGray稍暗一点
          BufferLineWarningDiagnosticVisible = { fg = bufferLine_diagnostic, bg = "#1c1c1c" },
          BufferLineWarningDiagnostic = { fg = bufferLine_diagnostic, bg = "#171717", sp = "#a5a57f" },
          BufferLineInfoDiagnostic = { fg = bufferLine_diagnostic, bg = "#171717", sp = "#4075a0" },
          BufferLineHintDiagnosticVisible = { fg = bufferLine_diagnostic, bg = "#1c1c1c" },
          BufferLineHintDiagnostic = { fg = bufferLine_diagnostic, bg = "#171717", sp = "#4075a0" },
          BufferLineDiagnosticVisible = { fg = bufferLine_diagnostic, bg = "#1c1c1c" },
          BufferLineErrorDiagnostic = { fg = bufferLine_diagnostic, bg = "#171717", sp = "#b73535" },
          BufferLineInfoDiagnosticVisible = { fg = bufferLine_diagnostic, bg = "#1c1c1c" },
          BufferLineDiagnostic = { fg = bufferLine_diagnostic, bg = "#171717" },
          BufferLineErrorDiagnosticVisible = { fg = bufferLine_diagnostic, bg = "#1c1c1c" },

          -- flash搜索时，背景变灰色
          FlashBackdrop = { fg = c.vscGray },
          -- lazygit, 在此定义highlight，在snacks.nvim中配置
          LazyGitActiveBorderColor = { fg = c.vscBlueGreen },
          LazyGitInactiveBorderColor = { fg = c.vscGray },
          LazyGitSearchingActiveBorderColor = { fg = c.vscBlueGreen },
          -- neo-tree
          NeoTreeCursorLine = { bg = "#292929" },
          NeoTreeIndentMarker = { fg = "#5a5a5a" },
          NeoTreeExpander = { fg = "#a0a0a0" },
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
          WhichKeyBorder = { fg = c.vscGray, bg = "#1a1a1a" },
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

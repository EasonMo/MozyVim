return {
  -- 修改区块选择
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      incremental_selection = {
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = "<tab>",
          node_decremental = "<bs>",
        },
        is_supported = function()
          local mode = vim.api.nvim_get_mode().mode
          -- 解决命令窗口按回车报错
          if mode == "c" then
            return false
          end
          local filetype = vim.opt_local.filetype:get()
          -- 解决dap-repl按回车不触发命令
          if filetype == "dap-repl" then
            return false
          end

          return true
        end,
      },
    },
  },
  -- 缩进线显示
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = function(_, opts)
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "custom_indent_highlight", { fg = "#313131" })
      end)

      opts.indent = {
        char = "╎",
        tab_char = "╎",
        highlight = "custom_indent_highlight",
      }
    end,
  },
  -- 补全
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      -- NOTE: 没相到合并按键映射这样搞的
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- 添加cmp补全的按键
        ["<M-/>"] = cmp.mapping.complete(),
        -- 手动关闭补全: 关闭高亮
        ["<C-e>"] = cmp.mapping(function()
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.stop()
          end
          cmp.mapping.abort()
        end, { "i", "s" }),
      })
    end,
  },
  -- 解决sudo保存文件
  {
    "lambdalisue/vim-suda",
    cmd = {
      "SudaWrite",
    },
  },
  -- 成对符号处理
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  -- 驼峰命名转换
  {
    "gregorias/coerce.nvim",
    tag = "v2.2",
    event = "VeryLazy",
    config = function()
      local coerce_m = require("coerce")
      local selector_m = require("coerce.selector")
      local transformer_m = require("coerce.transformer")
      local coroutine_m = require("coerce.coroutine")
      local keymap_m = require("coerce.keymap")

      coerce_m.setup({
        modes = {
          {
            vim_mode = "n",
            keymap_prefix = "<LocalLeader>c",
            selector = selector_m.select_current_word,
            transformer = function(selected_region, apply)
              return coroutine_m.fire_and_forget(
                transformer_m.transform_lsp_rename_with_local_failover,
                selected_region,
                apply
              )
            end,
          },
          {
            vim_mode = "n",
            keymap_prefix = "<LocalLeader>cg",
            selector = selector_m.select_with_motion,
            transformer = transformer_m.transform_local,
          },
          {
            vim_mode = "v",
            keymap_prefix = "<localleader>c",
            selector = selector_m.select_current_visual_selection,
            transformer = transformer_m.transform_local,
          },
        },
      })
      coerce_m.register_case({
        keymap = "l",
        case = function(str)
          return vim.fn.tolower(str)
        end,
        description = "lowercase",
      })
      -- 覆盖默认的按键组说明
      keymap_m.keymap_registry().register_keymap_group("n", "<LocalLeader>cg", "motion slection (not lsp)")
    end,
  },
  -- 直接执行curl
  {
    "oysandvik94/curl.nvim",
    -- enabled = false,
    ft = "curl",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = { ensure_installed = { "jq" } },
      },
    },
    opts = {
      mappings = {
        execute_curl = "<localleader>h",
      },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "CurlCommandHighlight", {
        link = "Visual",
      })
      require("curl.config").setup(opts)
    end,
  },
  -- 重构
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      { "<leader>r", "", desc = "+refactor/runner", mode = { "n", "v" } },
    },
  },
  {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "task: run" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "task: toggle" },
      { "<leader>oa", "<cmd>OverseerQuickAction<cr>", desc = "task: quick action" },
      { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "task: restart last" },
    },
    --- @type overseer.Config Configuration options
    opts = {
      -- overseer与dap不同时初始化
      dap = false,
      templates = {
        "builtin",
        "user",
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, {})
      require("overseer").setup(opts)
    end,
  },
  {
    "folke/flash.nvim",
    -- stylua: ignore
    keys = {
      -- 删除x、o模式，与nvim-surround的S冲突
      { "S", mode = { "n" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
}

return {
  -- code runner
  {
    "CRAG666/code_runner.nvim",
    config = true,
    event = "VeryLazy",
    keys = {
      { "<leader>rr", "<cmd>RunCode<CR>", desc = "runner: Run Code" },
      { "<F8>", "<cmd>RunClose<CR><cmd>RunCode<CR>", desc = "runner: Run Code" },
      { "<leader>rx", "<cmd>RunClose<CR>", desc = "runner: Run Close" },
    },
    opts = function()
      return {
        term = {
          -- 运行窗口的位置
          position = "belowright",
        },
        filetype = {
          java = {
            "cd $dir &&",
            "javac $fileName &&",
            "java $fileNameWithoutExt",
          },
          python = { 'export PYTHONPATH="." &&', "python3 -u" },
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir/$fileNameWithoutExt",
          },
          c = {
            "cd $dir &&",
            "gcc $fileName -o",
            "/tmp/$fileNameWithoutExt",
            "&& /tmp/$fileNameWithoutExt &&",
            "rm /tmp/$fileNameWithoutExt",
          },
        },
      }
    end,
  },
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
    "snacks.nvim",
    opts = {
      indent = {
        indent = {
          char = "╎",
          hl = "custom_indent_highlight",
        },
      },
    },
  },
  -- 补全
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ["<M-/>"] = { "show", "show_documentation", "hide_documentation" },
      },
      enabled = function()
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false or require("cmp_dap").is_dap_buffer()
      end,
    },
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
    dependencies = {
      "folke/flash.nvim",
    },
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
  -- 任务系统
  {
    "stevearc/overseer.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Restart last" },
    },
    --- @type overseer.Config Configuration options
    opts = {
      templates = {
        "builtin",
        "user",
      },
      component_aliases = {
        default_vscode = {
          "default",
          { "user.on_output_quickfix_trouble", open = true },
        },
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
  -- flash
  {
    "folke/flash.nvim",
    -- stylua: ignore
    keys = {
      -- 删除x、o模式，与nvim-surround的S冲突
      { "S", mode = { "n" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  -- 增强增量/减量
  {
    "monaqa/dial.nvim",
    opts = function(_, opts)
      local augend = require("dial.augend")
      vim.list_extend(opts.groups.default, {
        augend.date.alias["%Y-%m-%d"],
        augend.date.new({ pattern = "%Y年%m月%d日", default_kind = "day", only_valid = true }),
      })
    end,
  },
}

return {
  -- formatter
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      if not require("util").file_exists("stylua.toml") then
        opts.formatters.stylua = {
          command = "stylua",
          args = {
            "--config-path",
            vim.fn.expand("~/.config/nvim/stylua.toml"),
            "--search-parent-directories",
            "--respect-ignores",
            "--stdin-filepath",
            "$FILENAME",
            "-",
          },
        }
      end
    end,
  },
  -- code runner
  {
    "CRAG666/code_runner.nvim",
    config = true,
    event = "VeryLazy",
    keys = {
      { "<leader>rr", "<cmd>wa | RunCode<CR>", desc = "runner: Run Code" },
      { "<F8>", "<cmd>RunClose<CR><cmd>wa | RunCode<CR>", desc = "runner: Run Code" },
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
          -- 在 ~/.bash_profile 中添加 export PYTHONPATH=".:$PYTHONPATH"
          python = { "python3 -u" },
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName -o /tmp/$fileNameWithoutExt &&",
            "/tmp/$fileNameWithoutExt &&",
            "rm /tmp/$fileNameWithoutExt",
          },
          c = {
            "cd $dir &&",
            "gcc $fileName -o /tmp/$fileNameWithoutExt &&",
            "/tmp/$fileNameWithoutExt &&",
            "rm /tmp/$fileNameWithoutExt",
          },
          go = {
            "cd $dir &&",
            "f=$fileName && [[ ${f##*.} = go ]] && go run $f || (cp $f $f.go && go run $f.go && rm $f.go)",
          },
        },
      }
    end,
  },
  -- snacks定制: 图片显示, scratch运行代码
  {
    "snacks.nvim",
    opts = function(_, opts)
      -- scratch运行代码
      local python = {
        keys = {
          ["source"] = {
            "<cr>",
            function(self)
              local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
              require("util.scratch").runPython({ buf = self.buf, name = name })
            end,
            desc = "Run buffer",
            mode = { "n", "x" },
          },
        },
      }
      if opts.scratch == nil then
        opts.scratch = { win_by_ft = { python = python } }
      else
        opts.scratch.win_by_ft.python = python
      end
      -- 图片显示过滤掉非kitty终端
      if string.find(vim.fn.getenv("TERM"), "kitty") then
        opts.image = {}
      end
    end,
  },
  -- 补全
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ["<M-/>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "show", "select_next" },
        ["<C-p>"] = { "show", "select_prev" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },
      enabled = function()
        local normal = vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
        if not normal then
          local dap = require("cmp_dap").is_dap_buffer()
          if dap then
            vim.b.completion = true
            return true
          end
        end
        return normal
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
        "mason-org/mason.nvim",
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
        augend.constant.new({
          elements = { "周一", "周二", "周三", "周四", "周五", "周六", "周日" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日" },
          word = false,
          cyclic = true,
        }),
      })
    end,
  },
}

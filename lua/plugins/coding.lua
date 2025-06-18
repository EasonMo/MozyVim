return {
  -- formatter
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      if not require("utils").file_exists("stylua.toml") then
        opts.formatters_by_ft.lua = {
          command = "stylua",
          args = { "--config-path", vim.fn.expand("~/.config/nvim/stylua.toml") },
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
            "go run $fileName",
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
  -- snacks定制: 图片显示, scratch运行代码
  {
    "snacks.nvim",
    opts = function(_, opts)
      local defaults = {
        name = "Output",
        ft = vim.bo.filetype,
        ---@type string|string[]?
        icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
        win = { style = "output" },
      }

      local output_height = 20
      Snacks.config.style("output", {
        width = 0,
        height = output_height,
        backdrop = false,
        row = vim.api.nvim_get_option_value("lines", {}) - output_height,
        border = "top",
        bo = {
          buftype = "nofile",
          buflisted = false,
          bufhidden = "wipe",
          swapfile = false,
          undofile = false,
          modifiable = false, -- 不可修改
        },
        minimal = false,
        noautocmd = false,
        zindex = 100,
        ft = "output",
        wo = {
          -- 默认highlight: "NormalFloat:Normal,FloatBorder:WinSeparator",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:WhichKeyBorder,CursorLine:NeoTreeCursorLine",
          colorcolumn = "",
          number = false,
          relativenumber = false,
        },
      })

      --- Show lines in a floating buffer at the bottom.
      ---@param lines string
      ---@param fopts? snacks.scratch.Config
      local function show_output(lines, fopts)
        fopts = Snacks.config.get("output", defaults, fopts)
        fopts.win = Snacks.win.resolve("output", fopts.win, { show = false })

        local out_buf = vim.api.nvim_create_buf(false, true)

        local content = {}
        for line in lines:gmatch("([^\n]*)\n?") do
          table.insert(content, line)
        end
        -- Remove trailing empty lines
        for i = #content, 1, -1 do
          if content[i] == "" then
            table.remove(content, i)
          else
            break
          end
        end
        vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, content)
        fopts.win.buf = out_buf
        return Snacks.win(fopts.win):show()
      end

      --- Run the current buffer or a range of lines.
      --- Shows the output in a scratch buffer at the bottom.
      ---@param fopts? {name?:string, buf?:number, print?:boolean}
      local function runPython(fopts)
        local ns = vim.api.nvim_create_namespace("snacks_debug")
        fopts = vim.tbl_extend("force", { print = true }, fopts or {})
        local buf = fopts.buf or 0
        buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
        local name = fopts.name or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")

        -- Get the lines to run
        local lines ---@type string[]
        local mode = vim.fn.mode()
        if mode:find("[vV]") then
          if mode == "v" then
            vim.cmd("normal! v")
          elseif mode == "V" then
            vim.cmd("normal! V")
          end
          local from = vim.api.nvim_buf_get_mark(buf, "<")
          local to = vim.api.nvim_buf_get_mark(buf, ">")

          -- for some reason, sometimes the column is off by one
          -- see: https://github.com/folke/snacks.nvim/issues/190
          local col_to = math.min(to[2] + 1, #vim.api.nvim_buf_get_lines(buf, to[1] - 1, to[1], false)[1])

          lines = vim.api.nvim_buf_get_text(buf, from[1] - 1, from[2], to[1] - 1, col_to, {})
          -- Insert empty lines to keep the line numbers
          for _ = 1, from[1] - 1 do
            table.insert(lines, 1, "")
          end
          vim.fn.feedkeys("gv", "nx")
        else
          lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        end

        -- Clear diagnostics and extmarks
        local function reset()
          vim.diagnostic.reset(ns, buf)
          vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        end
        reset()
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
          group = vim.api.nvim_create_augroup("snacks_debug_run_" .. buf, { clear = true }),
          buffer = buf,
          callback = reset,
        })

        local command = "echo " .. vim.fn.shellescape(table.concat(lines, "\n")) .. " | python3 2>&1"
        local handle = io.popen(command)
        if not handle then
          Snacks.notify.error("Didn't get popen handle.", { title = name })
          return
        end
        local out = handle:read("*a")
        handle:close()

        if out == "" then
          Snacks.notify.info("No output.", { title = name, ft = "python" })
        else
          show_output(out)
        end
      end

      -- scratch运行代码
      local python = {
        keys = {
          ["source"] = {
            "<cr>",
            function(self)
              local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
              runPython({ buf = self.buf, name = name })
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
  -- grug-far：搜索替换
  {
    "grug-far.nvim",
    opts = {
      keymaps = {
        replace = { n = "<localleader>rr" },
        qflist = { n = "<localleader>rq" },
        syncLocations = { n = "<localleader>rs" },
        syncLine = { n = "<localleader>rl" },
        close = { n = "<localleader>rc" },
        historyOpen = { n = "<localleader>rt" },
        historyAdd = { n = "<localleader>ra" },
        refresh = { n = "<localleader>rf" },
        openLocation = { n = "<localleader>ro" },
        openNextLocation = { n = "<down>" },
        openPrevLocation = { n = "<up>" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = "<localleader>rb" },
        help = { n = "g?" },
        toggleShowCommand = { n = "<localleader>rw" },
        swapEngine = { n = "<localleader>re" },
        previewLocation = { n = "<localleader>ri" },
        swapReplacementInterpreter = { n = "<localleader>rx" },
        applyNext = { n = "<localleader>rj" },
        applyPrev = { n = "<localleader>rk" },
        syncNext = { n = "<localleader>rn" },
        syncPrev = { n = "<localleader>rp" },
        syncFile = { n = "<localleader>rv" },
        nextInput = { n = "<tab>" },
        prevInput = { n = "<s-tab>" },
      },
    },
  },
}

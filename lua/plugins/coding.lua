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
      },
    },
  },
  -- 修改配置，只修改单一项
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = function(_, opts)
      opts.indent = {
        char = "╎",
        tab_char = "╎",
      }
    end,
  },
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
      local selector_m = require("coerce.selector")
      local transformer_m = require("coerce.transformer")
      local coroutine_m = require("coerce.coroutine")

      require("coerce").setup({
        modes = {
          {
            vim_mode = "n",
            keymap_prefix = "<localleader>c",
            selector = selector_m.select_current_word,
            transformer = function(selected_region, apply)
              return coroutine_m.fire_and_forget(
                transformer_m.transform_lsp_rename_with_local_failover,
                selected_region,
                apply
              )
            end,
          },
        },
      })
      require("coerce").register_case({
        keymap = "l",
        case = function(str)
          return vim.fn.tolower(str)
        end,
        description = "lowercase",
      })
    end,
  },
}

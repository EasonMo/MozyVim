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
      keymap_m.keymap_registry().register_keymap_group("n", "<LocalLeader>cg", "motion slection")
    end,
  },
}

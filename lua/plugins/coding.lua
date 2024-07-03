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
  -- 用lsp来做的代码格式化和诊断
  -- python: 诊断用pyright，格式化用ruff_lsp
  {
    "neovim/nvim-lspconfig",
    -- 直接写opts也能合并配置, 用有返回值的function才是override
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright = {
        --   -- capabilities = {
        --   --   textDocument = {
        --   --     publishDiagnostics = {
        --   --       tagSupport = { 2 },
        --   --     },
        --   --   },
        --   -- },
        --   settings = {
        --     python = {
        --       analysis = {
        --         autoImportCompletions = true,
        --         autoSearchPaths = true,
        --         -- diagnosticMode = "workspace", -- ["openFilesOnly", "workspace"]
        --         useLibraryCodeForTypes = true,
        --         -- typeCheckingMode = "off",
        --         -- typeCheckingMode = "basic",
        --         diagnosticSeverityOverrides = { -- "error," "warning," "information," "true," "false," or "none"
        --           -- reportArgumentType = false,
        --           reportUnusedCoroutine = false,
        --         },
        --       },
        --     },
        --   },
        -- },
        ruff_lsp = {
          init_options = {
            settings = {
              format = {
                args = {
                  "--line-length=100",
                  -- "--ignore=E501,E722,COM812",
                },
              },
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=webkit",
          },
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
  -- Use <tab> for completion and snippets (supertab)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
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
}

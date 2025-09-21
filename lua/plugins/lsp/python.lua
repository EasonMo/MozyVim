-- 用lsp来做的代码格式化和诊断
-- pyright: 诊断, 代码补全, 重构
-- ruff: 格式化, 静态分析
return {
  "neovim/nvim-lspconfig",
  -- 直接写opts也能合并配置, 用有返回值的function才是override
  ---@class PluginLspOpts
  opts = {
    servers = {
      pyright = { -- basedpyright只是订制版的pyright
        -- 修复root dir错误设置的问题
        ---@type fun(bufnr: integer, on_dir:fun(root_dir?:string))
        root_dir = function(bufnr, on_dir)
          local fname = vim.fn.bufname(bufnr)
          on_dir(
            require("lspconfig.util").root_pattern(
              vim.lsp.config["pyright"].root_markers,
              require("util").general_root,
              {
                "venv/",
              }
            )(fname) or vim.fs.dirname(fname)
          )
        end,
        single_file_support = true,
        -- capabilities = {
        --   textDocument = {
        --     publishDiagnostics = {
        --       tagSupport = { 2 },
        --     },
        --   },
        -- },
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              -- diagnosticMode = "workspace", -- ["openFilesOnly", "workspace"]
              useLibraryCodeForTypes = true,
              typeCheckingMode = "off",
              -- typeCheckingMode = "basic", -- off, basic, strict
              diagnosticSeverityOverrides = { -- "error," "warning," "information," "true," "false," or "none"
                -- reportArgumentType = false,
                reportUnusedCoroutine = false,
                reportUnusedImport = false,
              },
            },
          },
        },
      },
      ruff = {
        init_options = {
          settings = {
            configuration = vim.fn.expand("~/.config/nvim/pyproject.toml"),
          },
        },
      },
    },
  },
}

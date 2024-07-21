-- 用lsp来做的代码格式化和诊断
-- python: 诊断用pyright，格式化用ruff_lsp
local general_root = require("utils").general_root
local util = require("lspconfig/util")
local py_root = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
  "venv/",
}
return {
  "neovim/nvim-lspconfig",
  -- 直接写opts也能合并配置, 用有返回值的function才是override
  ---@class PluginLspOpts
  opts = {
    servers = {
      pyright = {
        -- 修复root dir错误设置的问题
        root_dir = function(fname)
          return util.root_pattern(unpack(vim.tbl_extend("force", py_root, general_root)))(fname)
            or util.find_git_ancestor(fname)
            or util.path.dirname(fname)
        end,
        single_file_support = true,
        -- capabilities = {
        --   textDocument = {
        --     publishDiagnostics = {
        --       tagSupport = { 2 },
        --     },
        --   },
        -- },
        -- settings = {
        --   python = {
        --     analysis = {
        --       autoImportCompletions = true,
        --       autoSearchPaths = true,
        --       -- diagnosticMode = "workspace", -- ["openFilesOnly", "workspace"]
        --       useLibraryCodeForTypes = true,
        --       -- typeCheckingMode = "off",
        --       -- typeCheckingMode = "basic",
        --       diagnosticSeverityOverrides = { -- "error," "warning," "information," "true," "false," or "none"
        --         -- reportArgumentType = false,
        --         reportUnusedCoroutine = false,
        --       },
        --     },
        --   },
        -- },
      },
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
    },
  },
}

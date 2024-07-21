return {
  "neovim/nvim-lspconfig",
  -- 直接写opts也能合并配置, 用有返回值的function才是override
  ---@class PluginLspOpts
  opts = {
    servers = {
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
}

-- 参考配置：https://github.com/JorgeHerreraU/nvim/blob/cc1e00e47511e8a4b1d3209a0a280ae6e0e7d6bd/lua/custom/plugins/lspconfig.lua#L209
return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      vtsls = {
        -- 原始配置：nvim-lspconfig/lsp/vtsls.lua
        root_dir = function(bufnr, on_dir)
          local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
          root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
            or vim.list_extend(root_markers, { ".git" })

          local project_root = vim.fs.root(bufnr, root_markers)
          if project_root == vim.fn.expand("~") then
            project_root = vim.fn.getcwd()
          end

          on_dir(project_root)
        end,
        handlers = {
          ["textDocument/publishDiagnostics"] = function(_, result, ctx)
            if result.diagnostics ~= nil then
              local idx = 1
              while idx <= #result.diagnostics do
                -- 8001 File is a commonjs module
                if result.diagnostics[idx].code == 80001 then
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
          end,
        },
      },
    },
  },
}

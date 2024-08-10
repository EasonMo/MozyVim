-- 参考配置：https://github.com/JorgeHerreraU/nvim/blob/cc1e00e47511e8a4b1d3209a0a280ae6e0e7d6bd/lua/custom/plugins/lspconfig.lua#L209
return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      vtsls = {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
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
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
          end,
        },
      },
    },
  },
}

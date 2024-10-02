return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      -- 直接去掉markdown的诊断信息，缺点：不能格式化
      -- linters_by_ft = {
      --   markdown = {},
      -- },
      linters = {
        ["markdownlint-cli2"] = {
          -- 注意：使用的是.markdownlint.yaml，而非.markdownlint-cli2.yaml，两者的配置格式有区别
          args = { "--config", vim.fn.expand("~/.config/nvim/.markdownlint.yaml"), "--" },
        },
      },
    },
  },
  -- 过滤markdown诊断信息，弃用，同样会导致不能格式化
  -- {
  --   "m-gail/diagnostic_manipulation.nvim",
  --   init = function()
  --     local function md_error(diagnostic)
  --       -- print(diagnostic.message)
  --       return diagnostic.source == "markdownlint"
  --     end
  --     require("diagnostic_manipulation").setup({
  --       blacklist = {
  --         md_error,
  --       },
  --       whitelist = {
  --         -- Your whitelist here
  --       },
  --     })
  --   end,
  -- },
}

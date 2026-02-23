return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "rust-analyzer" } },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations.rust = dap.configurations.c
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        status_notify_level = false, -- 禁止单文件使用时的警告
      },
    },
  },
}

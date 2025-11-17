return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        -- 同步：/nvim-lint/lua/lint/linters/sqlfluff.lua
        ["sqlfluff"] = {
          args = {
            "lint",
            "--format=json",
            "--config=" .. vim.fn.expand("~/.config/nvim/.sqlfluff"),
          },
        },
      },
    },
  },
}

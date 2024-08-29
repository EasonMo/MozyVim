return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- 去掉markdown烦人的诊断信息
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}

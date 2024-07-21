-- 解决python调试的问题，config基于原生的
-- 参考: github搜索 nvim-dap-python include_configs
return {
  {
    "mfussenegger/nvim-dap-python",
    opts = function(_, opts)
      opts.pythonPath = vim.loop.os_uname().sysname == "Linux" and "/usr/bin/python3" or "/usr/local/bin/python3"
      opts.cwd = vim.fn.getcwd()
      opts.include_configs = false
      -- 修改mason-nvim-dap的python默认设置
      local configurations = require("mason-nvim-dap.mappings.configurations")
      configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Python: Launch file (cwd)",
          program = "${file}",
          console = "integratedTerminal",
          -- justMyCode = false,
          cwd = opts.cwd,
          env = {
            PYTHONPATH = opts.cwd,
          },
        },
      }
    end,
    config = function(_, opts)
      -- 添加launch的示例
      -- require("dap").configurations.python = {
      --   {
      --     type = "python",
      --     request = "launch",
      --     name = "Python: Launch file (cwd)",
      --     program = "${file}",
      --     console = "integratedTerminal",
      --     justMyCode = false,
      --     cwd = opts.cwd,
      --     env = {
      --       PYTHONPATH = opts.cwd,
      --     },
      --   },
      -- }
      -- 不需要python虚拟环境，直接设为nil，覆盖lazyvim的配置
      require("dap-python").setup(nil, opts)
    end,
  },
}

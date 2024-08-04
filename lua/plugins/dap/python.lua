-- 解决python调试的问题，config基于原生的
-- 参考:
--   1. github搜索 nvim-dap-python include_configs
--   2. https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings

local function get_python_packages_paths()
  -- 此方法彻底解决python包路径的问题
  local result = vim.fn.systemlist("python3 -c \"import sys; print('\\n'.join(sys.path))\"")
  local python_paths = table.concat(result, ":")
  return python_paths
end
return {
  {
    "mfussenegger/nvim-dap-python",
    opts = function(_, opts)
      -- 禁止nvim-dap-python默认添加的configurations
      opts.include_configs = false
    end,
    config = function(_, opts)
      -- 添加dap的运行配置
      require("dap").configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Python: Launch file (cwd)",
          program = "${file}",
          -- 使用插件内置的Terminal，否则在调试窗口运行
          console = "integratedTerminal",
          justMyCode = false,
          cwd = vim.fn.getcwd(),
          env = {
            PYTHONPATH = get_python_packages_paths(),
          },
        },
      }
      -- nvim-dap-python默认没有使用opts参数，在此处重新setup
      require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"), opts)
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- 启动debug时传过去的配置
          dap = {
            -- justMyCode = false,
            console = "integratedTerminal",
            env = {
              PYTHONPATH = get_python_packages_paths(),
            },
          },
        },
      },
    },
  },
}

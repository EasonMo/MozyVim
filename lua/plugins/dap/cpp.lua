return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        -- 删除mason的默认配置
        cppdbg = function() end,
        codelldb = function() end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.exepath("OpenDebugAD7"),
      }
      -- 覆盖lazyVim的c/cpp配置
      local c_config = {}
      -- mac不支持gdb
      if vim.uv.os_uname().sysname ~= "Darwin" then
        table.insert(c_config, 1, {
          name = "cppdbg: Launch active file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return "${fileDirname}/${fileBasenameNoExtension}.out"
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          stopAtBeginningOfMainSubprogram = false,
          miDebuggerArgs = "--quiet",
          targetArchitecture = "x64",
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        })
      end
      table.insert(c_config, {
        name = "LLDB: Launch active file",
        type = "codelldb",
        request = "launch",
        program = function()
          -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          return "${fileDirname}/${fileBasenameNoExtension}.out"
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        stopAtBeginningOfMainSubprogram = false,
        -- args = {},
      })
      dap.configurations.c = c_config
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}

return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      table.insert(dap.configurations["c"], {
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
      -- gdb参考文档：https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-gdb
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
        -- args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }
      table.insert(dap.configurations["c"], {
        name = "GDB: Launch active file",
        type = "gdb",
        request = "launch",
        program = function()
          return "${fileDirname}/${fileBasenameNoExtension}.out"
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        stopAtBeginningOfMainSubprogram = false,
      })
    end,
  },
}

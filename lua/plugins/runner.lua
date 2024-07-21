return {
  "CRAG666/code_runner.nvim",
  config = true,
  event = "VeryLazy",
  keys = {
    { "<leader>rr", "<cmd>RunCode<CR>", desc = "runner: Run Code" },
    { "<leader>rx", "<cmd>RunClose<CR>", desc = "runner: Run Close" },
  },
  opts = function(_, opts)
    return {
      -- mode = "float",
      -- float = {
      --   border = "rounded",
      -- },
      term = {
        -- 运行窗口的位置
        position = "belowright",
      },
      filetype = {
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
        python = { 'export PYTHONPATH="." &&', "python3 -u" },
        typescript = "deno run",
        rust = {
          "cd $dir &&",
          "rustc $fileName &&",
          "$dir/$fileNameWithoutExt",
        },
        c = function(...)
          local c_base = {
            "cd $dir &&",
            "gcc $fileName -o",
            "/tmp/$fileNameWithoutExt",
          }
          local c_exec = {
            "&& /tmp/$fileNameWithoutExt &&",
            "rm /tmp/$fileNameWithoutExt",
          }
          vim.ui.input({ prompt = "Add more args:" }, function(input)
            c_base[4] = input
            vim.print(vim.tbl_extend("force", c_base, c_exec))
            require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
          end)
        end,
      },
    }
  end,
}

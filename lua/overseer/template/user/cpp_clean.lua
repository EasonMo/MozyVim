return {
  name = "nvim: gcc clean",
  builder = function()
    local cmd_file = vim.fn.stdpath("config") .. "/tools/rm_gcc_build.sh"
    return {
      cmd = { "sh" },
      args = { cmd_file },
      components = {
        "default",
      },
    }
  end,
  condition = {
    filetype = { "c", "cpp" },
  },
}

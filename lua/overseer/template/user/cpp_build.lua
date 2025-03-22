return {
  name = "nvim: gcc build active file",
  builder = function()
    local file = vim.fn.expand("%:.")
    local filetype = vim.fn.expand("%:e")
    local gcc_cmd = "gcc"
    if filetype == "cpp" then
      gcc_cmd = "g++"
    end
    local out = vim.fn.expand("%:.:r") .. ".out"
    return {
      cmd = { gcc_cmd },
      args = { "-g", file, "-o", out },
      components = {
        -- { "on_output_quickfix", open = true },
        { "user.on_output_quickfix_trouble", open = true },
        -- "on_result_diagnostics",
        -- { "restart_on_save", paths = { vim.fn.expand("%:p") } },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "c", "cpp" },
  },
}

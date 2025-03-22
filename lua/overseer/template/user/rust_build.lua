return {
  name = "nvim: build active file",
  builder = function()
    local file = vim.fn.expand("%:.")
    local out = vim.fn.expand("%:.:r") .. ".out"
    return {
      cmd = { "rustc" },
      args = { "-g", file, "-o", out },
      components = {
        { "user.on_output_quickfix_trouble", open = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "rust" },
  },
}

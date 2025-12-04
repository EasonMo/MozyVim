return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {
          filetypes = { "disable" },
        },
      },
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        win = {
          keys = {
            files = { "<c-g>", "files", mode = "nt", desc = "open file picker" },
          },
        },
      },
      nes = { enabled = false },
    },
  },
}

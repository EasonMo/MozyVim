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
      nes = { enabled = false },
    },
  },
}

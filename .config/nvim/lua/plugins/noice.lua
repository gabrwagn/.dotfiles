return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
    },
    views = {
      cmdline_popup = {
        border = {
          style = "single",
        },
        position = {
          row = 70,
          col = "50%",
        },
        win_options = {
          winblend = 0,
        },
      },
    },
  },
}

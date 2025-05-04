return {
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>xx",
        function()
          require("fzf-lua").diagnostics_workspace({ actions = require("fzf-lua.actions").trouble })
        end,
        desc = "Diagnostics workspace(Trouble)",
      },
      {
        "<leader>xX",
        function()
          require("fzf-lua").diagnostics_document({ actions = require("fzf-lua.actions").trouble })
        end,
        desc = "Diagnostics Document (Trouble)",
      },
    },
  },
}

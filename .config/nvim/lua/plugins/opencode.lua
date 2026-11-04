return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        -- Only attach to the running background service; never launch opencode inside nvim.
        start = false,
      },
    }

    vim.keymap.set({ "n", "x" }, "<leader>aq", function() require("opencode").ask("@this: ") end,                    { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<leader>ax", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "x" }, "<leader>ap", function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
  end,
}

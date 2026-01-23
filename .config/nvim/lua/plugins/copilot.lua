return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  config = function()
    require("copilot").setup {
    copilot_model = "claude-sonnet-4.5",
    suggestion = {
      enabled = not vim.g.ai_cmp,
      auto_trigger = true,
      hide_during_completion = vim.g.ai_cmp,
      keymap = {
        accept = false, -- handled by nvim-cmp / blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  }
  end
}

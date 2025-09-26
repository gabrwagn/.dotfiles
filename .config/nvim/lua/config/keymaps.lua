-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map({ "n" }, "<D-p>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map({ "n" }, "<C-TAB>", ":bnext<cr>", { desc = "Find files" })
map({ "n" }, "<C-S-TAB>", ":bprev<cr>", { desc = "Find files" })
map("i", "<S-Tab>", "<C-d>")
map("n", "<Tab>", ">>")
map("n", "<S-Tab>", "<<")
map("v", "<Tab>", ">gv")
map("v", "<S-Tab>", "<gv")
map('n', '<C-i>', '<C-i>') -- Distinguish <Tab> from <C-i> in normal mode, allowing jump in history despite <Tab> being remapped

map('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = "Switch Source/Header" })

map('n', '<leader>gd', function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd('DiffviewOpen')
    else
      vim.cmd('DiffviewClose')
    end
  end
, { desc = "Git diff view"})


map("n", "<leader>xx", function()
  require("fzf-lua").diagnostics_workspace({ actions = require("fzf-lua.actions").trouble })
end, { desc = "Diagnostics (Troube=>fzf-lua)", silent = true })

map("n", "<leader>xX", function()
  require("fzf-lua").diagnostics_document({ actions = require("fzf-lua.actions").trouble })
end, { desc = "Diagnostics (Troube=>fzf-lua)", silent = true })

map("n", "glc", function() require("timber.actions").clear_log_statements({ global = false }) end, { desc = "Clear log statements in current buffer" })
map("n", "gls", function() require("timber.actions").search_log_statements() end, { desc = "search_log_statements" })

local wk = require("which-key")
wk.add {
  { '', group = 'Github' },
  { '<leader>gtc', group = 'Commits' },
  { '<leader>gtcc', '<cmd>GHCloseCommit<cr>', desc = 'Close' },
  { '<leader>gtce', '<cmd>GHExpandCommit<cr>', desc = 'Expand' },
  { '<leader>gtco', '<cmd>GHOpenToCommit<cr>', desc = 'Open To' },
  { '<leader>gtcp', '<cmd>GHPopOutCommit<cr>', desc = 'Pop Out' },
  { '<leader>gtcz', '<cmd>GHCollapseCommit<cr>', desc = 'Collapse' },
  { '<leader>gti', group = 'Issues' },
  { '<leader>gtip', '<cmd>GHPreviewIssue<cr>', desc = 'Preview' },
  { '<leader>gtl', group = 'Litee' },
  { '<leader>gtlt', '<cmd>LTPanel<cr>', desc = 'Toggle Panel' },
  { '<leader>gtp', group = 'Pull Request' },
  { '<leader>gtpc', '<cmd>GHClosePR<cr>', desc = 'Close' },
  { '<leader>gtpd', '<cmd>GHPRDetails<cr>', desc = 'Details' },
  { '<leader>gtpe', '<cmd>GHExpandPR<cr>', desc = 'Expand' },
  { '<leader>gtpo', '<cmd>GHOpenPR<cr>', desc = 'Open' },
  { '<leader>gtpp', '<cmd>GHPopOutPR<cr>', desc = 'PopOut' },
  { '<leader>gtpr', '<cmd>GHRefreshPR<cr>', desc = 'Refresh' },
  { '<leader>gtpt', '<cmd>GHOpenToPR<cr>', desc = 'Open To' },
  { '<leader>gtpz', '<cmd>GHCollapsePR<cr>', desc = 'Collapse' },
  { '<leader>gtr', group = 'Review' },
  { '<leader>gtrb', '<cmd>GHStartReview<cr>', desc = 'Begin' },
  { '<leader>gtrc', '<cmd>GHCloseReview<cr>', desc = 'Close' },
  { '<leader>gtrd', '<cmd>GHDeleteReview<cr>', desc = 'Delete' },
  { '<leader>gtre', '<cmd>GHExpandReview<cr>', desc = 'Expand' },
  { '<leader>gtrs', '<cmd>GHSubmitReview<cr>', desc = 'Submit' },
  { '<leader>gtrz', '<cmd>GHCollapseReview<cr>', desc = 'Collapse' },
  { '<leader>gtt', group = 'Threads' },
  { '<leader>gttc', '<cmd>GHCreateThread<cr>', desc = 'Create' },
  { '<leader>gttn', '<cmd>GHNextThread<cr>', desc = 'Next' },
  { '<leader>gttt', '<cmd>GHToggleThread<cr>', desc = 'Toggle' },
}

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
vim.opt.relativenumber = false

vim.g.snacks_animate = false
vim.g.autoformat = false

vim.opt.scrolloff = 999

vim.opt.fillchars = {
  eob = " ",
  diff = " ",
  msgsep = " "
}

-- diff opts
--
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "indent-heuristic",
  "linematch:60",
  "algorithm:histogram"
}

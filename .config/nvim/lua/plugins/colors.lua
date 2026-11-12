return {
  {
    -- Canonical name. RRethy/nvim-base16 was renamed to base16-nvim upstream
    -- and the old URL is only a redirect; both resolve to the same commit.
    -- Using the current name also makes noctalia's neovim community template
    -- decline to install itself: its apply.sh skips when plugins/ already
    -- greps for "base16-nvim". Colours still come from lua/colors.lua.
    "RRethy/base16-nvim",
    lazy = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end,
    },
  },
}

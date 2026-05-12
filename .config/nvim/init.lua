vim.opt.encoding = "utf-8"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("colors")

-- Roslyn LSP registry (desktop only)
if vim.fn.hostname() == "mononoke" then
    require("mason").setup({
        registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
        },
    })
end

-- Diffview
vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#20303b"})
vim.api.nvim_set_hl(0, "DiffDelete", {bg = "#37222c"})
vim.api.nvim_set_hl(0, "DiffChange", {bg = "#1f2231"})
vim.api.nvim_set_hl(0, "DiffText", {bg = "#394b70"})

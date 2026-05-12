return {
    "seblyng/roslyn.nvim",
    cond = vim.fn.hostname() == "mononoke",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
}

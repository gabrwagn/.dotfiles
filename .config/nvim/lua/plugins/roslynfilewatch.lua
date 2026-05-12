return {
    "khoido2003/roslyn-filewatch.nvim",
    cond = vim.fn.hostname() == "mononoke",
    config = function()
        require("roslyn_filewatch").setup({})
    end,
}

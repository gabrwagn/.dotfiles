return {
    "apyra/nvim-unity-sync",
    cond = vim.fn.hostname() == "mononoke",
    config = function()
        require("unity.plugin").setup({})
    end,
    ft = "cs",
}

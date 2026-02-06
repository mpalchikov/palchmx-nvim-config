return {
    "rebelot/kanagawa.nvim",
    config = function ()
        require("kanagawa").setup({
            transparent = false,
            keywordStyle = { italic = false }
        })
        vim.cmd("colorscheme kanagawa-dragon")
    end
}

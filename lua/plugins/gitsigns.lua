return {
    "lewis6991/gitsigns.nvim",
    config = function ()
        require("gitsigns").setup({
            signs = {
                add          = { text = "+" },
                change       = { text = "~" },
                delete       = { text = "-" },
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
                untracked    = { text = "┆" },
            },
        })

        vim.keymap.set("n", "<leader>gb", function()
                require("gitsigns").blame_line() 
            end, { desc = "[G]it [B]lame Line" })
    end
}

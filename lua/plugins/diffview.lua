return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "<leader>dv", "<CMD>DiffviewOpen<CR>", { desc = "Open Diffview" })
        vim.keymap.set("n", "<leader>dh", "<CMD>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
        vim.keymap.set("n", "<leader>dq", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" })
    end,
}

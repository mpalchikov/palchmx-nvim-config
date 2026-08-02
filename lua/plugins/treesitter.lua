return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate", -- Automatically installs parsers on first run.
    config = function()
        local treesitter = require("nvim-treesitter")

        treesitter.setup({})
        treesitter.install({ "c_sharp", "markdown", "lua", "json", "yaml", "proto", "razor", "http", "bash", "dockerfile", "xml", "typescript", "tsx" })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end,
}

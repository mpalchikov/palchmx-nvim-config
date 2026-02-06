return {
    "stevearc/quicker.nvim",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
    config = function()
        require("quicker").setup({
            opts = {
                number = true,
            },
            highlight = {
                -- Use treesitter highlighting
                treesitter = true,
                -- Use LSP semantic token highlighting
                lsp = false,
                -- Load the referenced buffers to apply more accurate highlights (may be slow)
                load_buffers = true,
            },
            edit = {
                -- Enable editing the quickfix like a normal buffer
                enabled = false,
                -- Set to true to write buffers after applying edits.
                -- Set to "unmodified" to only write unmodified buffers.
                autosave = "unmodified",
            },
            max_filename_width = function()
                return math.floor(math.min(45, vim.o.columns / 2))
            end,
            type_icons = {
                E = "E",
                W = "W",
                I = "I",
                N = "I",
                H = "I",
            },
        })
    end
}

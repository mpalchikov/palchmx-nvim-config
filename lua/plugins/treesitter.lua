return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Automatically installs parsers on first run.
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names to install.
            ensure_installed = { "c_sharp", "markdown", "lua", "json", "yaml", "proto", "razor" },

            -- Install parsers synchronously (recommended).
            sync_install = false,

            -- Autoinstall parsers for filetypes that are missing them.
            auto_install = true,

            highlight = {
                enable = true, -- Enable syntax highlighting.
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}

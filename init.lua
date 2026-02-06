-- Set up lazy.nvim plugin manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        opts = {},
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

vim.filetype.add({
    extension = {
        razor = "razor",
        cshtml = "razor",
    },
})

if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

-- Sync yanked text to the system clipboard automatically
vim.opt.clipboard = "unnamedplus"

require("settings")

require("lazy").setup({
    require("plugins.treesitter"),
    require("plugins.virt_column"),
    require("plugins.kanagawa"),
    require("plugins.dadbod"),
    require("plugins.mason"),
    require("plugins.roslyn"),
    require("plugins.telescope"),
    require("plugins.blink_cmp"),
    require("plugins.oil"),
    require("plugins.gitsigns"),
    require("plugins.lualine"),
    require("plugins.quicker"),
    require("plugins.mini_indentscope"),
    require("plugins.mini_move"),
    require("plugins.mini_splitjoin"),
    require("plugins.mini_cursorword"),
    require("plugins.treesitter_context"),
})

vim.diagnostic.config({
    float = {
        border = "single", -- Options: "single", "double", "rounded", "solid", "shadow"
        focusable = false,
        style = "minimal",
        header = "",
        prefix = "",
    },
})

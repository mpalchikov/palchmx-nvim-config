return {
    "lukas-reineke/virt-column.nvim",
    config = function ()
        require("virt-column").setup({
            virtcolumn = "120",
            char = "╵"
        })
    end
}

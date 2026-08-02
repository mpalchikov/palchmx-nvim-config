local function get_root_name()
    local project_markers = { ".git" }

    local root_path = vim.fs.root(0, project_markers)

    if root_path then
        local cleaned_path = root_path:gsub("/$", "")
        local root_name = vim.fn.fnamemodify(cleaned_path, ":t")
        return root_name
    end

    return "No Project"
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                refresh = {
                    tabline = 10000,
                }
            },
            sections = {
                lualine_a = {
                    { 
                        "mode",
                        fmt = function(str) return str:sub(1,1) end
                    }
                },
                lualine_b = {
                    { 
                        "filename",
                        path = 4
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = "E",
                            warn = "W",
                            info = "I",
                            hint = "H"
                        },
                        colored = true,
                    }
                },
                lualine_c = {},
                lualine_x = { "diff" },
                lualine_y = {}
            },
            tabline = {
                lualine_a = { get_root_name },
                lualine_b = 
                {
                    { "branch", separator = "" },
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
        })
    end
}

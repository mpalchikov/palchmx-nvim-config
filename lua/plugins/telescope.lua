return {
    "nvim-telescope/telescope.nvim", tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")
        local themes = require("telescope.themes")

        require("telescope").setup({
            extensions = {
                ["ui-select"] = {
                    themes.get_cursor() -- Apply cursor theme to ui-select
                }
            },
            pickers = {
                buffers = {
                    mappings = {
                        n = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                    },
                },
                live_grep = {
                    layout_config = {
                        preview_width = 0.5,
                    },
                },
                find_files = {
                    layout_config = {
                        preview_width = 0.7,
                    }
                },
                lsp_document_symbols = {
                    symbol_width = 100,
                },
                lsp_references = {
                    layout_strategy = "vertical",
                    fname_width = 100,
                    show_line = true,
                    trim_text = true,
                },
                diagnostics = {
                    layout_strategy = "vertical",
                    previewer = false,
                }
            },
            defaults = {
                layout_strategy = "horizontal",
                results_title = false,
                layout_config = {
                    width = 0.95,
                    height = 0.95,
                    vertical = {
                        prompt_position = "bottom",
                        mirror = false,
                        preview_height = 0.5
                    },
                    horizontal = {
                        preview_width = 0.5
                    },
                    preview_cutoff = 0,
                },
                path_display = { "smart" }, -- or "truncate", "filename", or a custom function
                preview = {
                    treesitter = true,
                },
                dynamic_preview_title = true,
            },
        })

        require("telescope").load_extension("ui-select")

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
        vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Telescope LSP references" })
        vim.keymap.set("n", "<leader>xd", builtin.diagnostics, { desc = "Telescope Diagnostics"})
        vim.keymap.set("n", "<leader>fu", builtin.git_status, { desc = "Telescope git status (uncommitted files)" })
        vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "[S]earch [S]ymbols (Document)" })

        vim.keymap.set(
            "n",
            "<leader>sd",
            function()
                builtin.diagnostics(
                    themes.get_dropdown({
                        bufnr = 0,
                        previewer = false,
                        layout_config = { width = 0.8, height = 0.6 }
                    }))
            end,
            { desc = "Telescope Diagnostics (current buffer)"}
        )

    end
}

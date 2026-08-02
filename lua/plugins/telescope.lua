return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")
        local previewers = require("telescope.previewers")
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
                        horizontal = {
                            preview_width = 0.5,
                        },
                    },
                },
                find_files = {
                    layout_config = {
                        horizontal = {
                            preview_width = 0.7,
                        },
                    }
                },
                lsp_document_symbols = {
                    symbol_width = 100,
                },
                lsp_references = {
                    layout_strategy = "flex",
                    fname_width = 100,
                    show_line = true,
                    trim_text = true,
                },
                diagnostics = {
                    layout_strategy = "flex",
                    previewer = false,
                }
            },
            defaults = {
                layout_strategy = "flex",
                results_title = false,
                layout_config = {
                    width = 0.95,
                    height = 0.95,
                    flex = {
                        flip_columns = 140,
                    },
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
        vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Telescope LSP references" })
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope Diagnostics"})
        vim.keymap.set("n", "<leader>fu", function()
            builtin.git_status({
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 140,
                    },
                    horizontal = {
                        preview_width = 0.65,
                    },
                    vertical = {
                        preview_height = 0.5,
                    },
                },
                previewer = previewers.new_termopen_previewer({
                    title = "Git File Diff Preview (difft)",
                    env = vim.tbl_extend("force", vim.fn.environ(), {
                        DFT_DISPLAY = "inline",
                        DFT_COLOR = "always",
                    }),
                    get_command = function(entry)
                        if not entry or not entry.value or entry.value == "" then
                            return nil
                        end

                        if entry.status == "??" or entry.status == "A " then
                            return {
                                "git",
                                "-c",
                                "diff.external=difft",
                                "--no-pager",
                                "diff",
                                "--no-index",
                                "--",
                                "/dev/null",
                                entry.value,
                            }
                        end

                        return {
                            "git",
                            "-c",
                            "diff.external=difft",
                            "--no-pager",
                            "diff",
                            "HEAD",
                            "--",
                            entry.value,
                        }
                    end,
                }),
            })
        end, { desc = "Telescope git status (uncommitted files)" })
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

        vim.keymap.set(
            "n",
            "<leader>sh",
            function()
                require("gitsigns").setqflist(0, {
                    use_location_list = true,
                    nr = 0,
                    open = false,
                }, function(err)
                    if err then
                        vim.notify("Gitsigns hunk collection failed: " .. err, vim.log.levels.ERROR)
                        return
                    end

                    builtin.loclist(
                        themes.get_dropdown({
                            previewer = false,
                            layout_config = { width = 0.8, height = 0.6 },
                        })
                    )
                end)
            end,
            { desc = "Telescope Hunks (current buffer)" }
        )

    end
}

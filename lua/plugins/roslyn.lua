return {
    "seblyng/roslyn.nvim",
    ---@module "roslyn.config"
    ---@type RoslynNvimConfig
    ft = { "cs", "razor" },
    lazy = false,
    config = function()
        local rzls_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec", ".razorExtension")

        local cmd = {
            "roslyn",
            "--stdio",
            "--logLevel=Information",
            "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
            "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
            "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
            "--extension=" .. vim.fs.joinpath(rzls_path, "Microsoft.VisualStudioCode.RazorExtension.dll"),
        }

        vim.lsp.config["roslyn"] = {
            filetypes = { "cs", "razor" },
            cmd = cmd,
            capabilities = {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true,
                    },
                },
            },
        }
    end,
    opts = {
        -- your configuration comes here; leave empty for default settings
    },
}

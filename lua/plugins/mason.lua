return {
    "williamboman/mason.nvim",
    opts = {
        registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
        },
        ensure_installed = {
            "lua-language-server",
            "xmlformatter",
            "csharpier",
            "prettier",
            "stylua",
            "json-lsp",
            "roslyn",
        },
    },
}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.showmode = false
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = "split"
vim.o.scrolloff = 10
vim.opt.fixeol = false
vim.opt.eol = false

-- Force undercurl support for Windows Terminal
vim.g.t_Cs = "\27[4:3m"
vim.g.t_Ce = "\27[4:0m"

-- Ensure termguicolors is on (required for curls)
vim.opt.termguicolors = true

vim.keymap.set('n', '<Space>', '<Nop>', { silent = true, remap = false })

vim.keymap.set('n', '<ESC>', ':nohlsearch<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

vim.keymap.set('n', '<leader>vgd', function()
  vim.cmd('vertical split | lua vim.lsp.buf.definition()')
end, { desc = 'Vertical split go to definition' })

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition)

vim.keymap.set('n', '<leader>fj', ':%!jq .<CR>', { desc = 'Format JSON with jq' })

vim.lsp.config['luals'] = {
  -- Command and arguments to start the server.
  cmd = { 'lua-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  },
}

vim.lsp.enable("luals")

vim.lsp.enable("roslyn")

vim.lsp.config['jsonls'] = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'package.json', '.git' },
  -- Required for completions to work properly in jsonls
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
}
vim.lsp.enable('jsonls')

vim.lsp.config['yamlls'] = {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  root_markers = { '.git' },
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      format = { enable = true },
      validate = true,
    },
  },
}
vim.lsp.enable('yamlls')

return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require("telescope.actions")
    local previewers = require("telescope.previewers")
    
    require('telescope').setup{
      pickers = {
          buffers = {
              mappings = {
                  n = {
                      ["<C-d>"] = actions.delete_buffer,
                  },
              },
          },
          git_status = {
              previewer = previewers.new_termopen_previewer({
                  get_command = function(entry)
                      if entry.status == "??" then
                          return { 'cat', entry.value }
                      end
                      return { 'sh', '-c', 'git diff --color=always -- ' .. vim.fn.shellescape(entry.value) .. ' | delta' }
                  end
              })
          },
      },
      defaults = {
          layout_strategy = "vertical",
          results_title = false,
          layout_config = {
              width = 0.85,
              vertical = {
                  prompt_position = "bottom",
                  mirror = false,
                  preview_height = 0.70
              }
          },
          path_display = { "smart" }, -- or "truncate", "filename", or a custom function
      },
    }

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>gr', builtin.lsp_references, { desc = 'Telescope LSP references' })
    vim.keymap.set('n', '<leader>xd', builtin.diagnostics, { desc = "Telescope Diagnostics"})
    vim.keymap.set('n', '<leader>fu', builtin.git_status, { desc = 'Telescope git status (uncommitted files)' })
  end
}
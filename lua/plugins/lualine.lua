local function get_root_name()
  -- Define project markers
  local project_markers = { '.git' }

  -- 1. Get the full root path
  local root_path = vim.fs.root(0, project_markers)

  if root_path then
    -- 2. Remove any trailing slash to ensure :t works correctly
    --    (e.g., changes "/home/user/project/" to "/home/user/project")
    local cleaned_path = root_path:gsub('/$', '')

    -- 3. Use fnamemodify with the :t modifier to get the tail (last path component)
    local root_name = vim.fn.fnamemodify(cleaned_path, ':t')
    
    return root_name
  end

  -- Fallback if no root is found
  return "No Project"
end

local function get_modified_buffers_count()
    local count = 0

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
          count = count + 1
        end
    end

    return count > 0 and ("M" .. count) or ""
end

local function get_global_errors()
  local count = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
  return count > 0 and ("E" .. count) or ""
end

local function get_global_warnings()
  local count = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
  return count > 0 and ("W" .. count) or ""
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
      require("lualine").setup({
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
              lualine_b = { "branch" },
              lualine_c = 
              {
                  { get_modified_buffers_count, color = { fg = '#ffffff' }, separator = "" },
                  { get_global_errors, color = { fg = '#ff0000' }, separator = "" },
                  { get_global_warnings, color = { fg = '#ff9e64' } }
              },
              lualine_x = {},
              lualine_y = {},
              lualine_z = {}
          },
      })
  end
}
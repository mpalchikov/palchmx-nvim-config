local git_cache = {
  uncommitted = "",
  unpushed = "",
  last_update = 0,
  refresh_interval = 5,
  is_updating = false
}

local function update_git_cache()
  local current_time = vim.loop.now() / 1000

  if (current_time - git_cache.last_update) < git_cache.refresh_interval or git_cache.is_updating then
    return
  end

  if not (vim.fn.isdirectory('.git') == 1 or vim.fn.filereadable('.git') == 1) then
    git_cache.uncommitted = ""
    git_cache.unpushed = ""
    git_cache.last_update = current_time
    return
  end

  git_cache.is_updating = true

  vim.fn.jobstart("git status --porcelain 2>/dev/null", {
    cwd = vim.fn.getcwd(),
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local result = table.concat(data, "\n")
        git_cache.uncommitted = (result ~= "" and result ~= "\n") and "[+]" or ""
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        git_cache.uncommitted = ""
      end

      vim.fn.jobstart("git rev-list --count @{upstream}..HEAD 2>/dev/null", {
        cwd = vim.fn.getcwd(),
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            local result = vim.trim(table.concat(data, "\n"))
            local count = tonumber(result) or 0
            git_cache.unpushed = count > 0 and "[↑]" or ""
          end
        end,
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            git_cache.unpushed = ""
          end
          git_cache.last_update = vim.loop.now() / 1000
          git_cache.is_updating = false
        end
      })
    end
  })
end

local function get_root_name()
  local project_markers = { '.git' }

  local root_path = vim.fs.root(0, project_markers)

  if root_path then
    local cleaned_path = root_path:gsub('/$', '')
    local root_name = vim.fn.fnamemodify(cleaned_path, ':t')
    return root_name
  end

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

local function get_uncommitted_indicator()
  if not (vim.fn.isdirectory('.git') == 1 or vim.fn.filereadable('.git') == 1) then 
    return ""
  end
  update_git_cache()
  return git_cache.uncommitted
end

local function get_unpushed_indicator()
  if not (vim.fn.isdirectory('.git') == 1 or vim.fn.filereadable('.git') == 1) then 
    return ""
  end
  update_git_cache()
  return git_cache.unpushed
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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
                    { get_uncommitted_indicator, separator = "" },
                    { get_unpushed_indicator }
                },
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
      
      -- Invalidate cache on buffer write
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          -- Force cache refresh on next call
          git_cache.last_update = 0
        end
      })
      
      -- Initial cache population
      vim.schedule(function()
        git_cache.last_update = 0
        update_git_cache()
      end)
  end
}

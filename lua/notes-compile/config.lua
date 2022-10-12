local M = {}

local defaults = {
  file_name = 'master.pdf',
  skip = { 'readme.md' },
  pandoc_args = {
    cmd_args = { '--toc', '-N' },
    format = {
      documentclass = 'extarticle',
      margin = '1cm',
      fontsize = '14pt'
    }
  }
}

M.get_ready_args = function ()
  local args = {}
  for _, entry in pairs(M.opt.pandoc_args) do
    if type(entry) == 'string' then table.insert(args, entry) goto continue end
    if type(entry) ~= 'table' then goto continue end

    for key, value in pairs(entry) do
      if type(key) == 'number' then table.insert(args, value) goto continue end
      table.insert(args, string.format('-V %s=%s', key, value))
      ::continue::
    end

    ::continue::
  end

  M.args = args
end

M.setup = function (opts)
  M.opt = require('plenary.tbl').freeze(
    vim.tbl_deep_extend('force', {}, defaults, opts or {})
  )
  -- opts = vim.tbl_extend("keep", opts, {silent = true, buffer = true})
  -- vim.keymap.set(mode, lhs, rhs, opts)

  M.get_ready_args()
end

return M

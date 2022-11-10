local M = {}

local defaults = {
  file_name = 'master.pdf',
  skip = { 'readme.md' },
  events = {},
  pandoc_args = {
    '--toc',
    '-N',
    { '-V', 'documentclass:extarticle' },
    { '-V', 'geometry:margin=1cm' },
    { '-V', 'fontsize=14pt' }
  }
}

M.get_ready_args = function()
  local args = {}
  for _, entry in pairs(M.opt.pandoc_args) do
    if type(entry) == 'string' then table.insert(args, entry) goto continue end
    if type(entry) ~= 'table' then goto continue end

    for _, value in pairs(entry) do
      table.insert(args, value)
    end

    ::continue::
  end

  M.args = require('plenary.tbl').freeze(args)
end

M.setup = function(opts)
  M.opt = require('plenary.tbl').freeze(
    vim.tbl_deep_extend('force', {}, defaults, opts or {})
  )

  M.get_ready_args()
end

return M

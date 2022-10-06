local M = {}

local defaults = {
  file_name = 'master.pdf',
  pandoc_options = { '--toc', '-N' },
  skip = { 'readme.md' },
  format = {
    geometry = {
      left = '1cm',
      top = '1cm',
      right = '1cm',
      bottom = '2cm'
    },
    documentclass = 'extarticle',
    fontsize = '14pt'
  }
}

M.setup = function (opts)
  M.opt = require('plenary.tbl').freeze(
    vim.tbl_deep_extend('force', {}, defaults, opts or {})
  )

end

return M

local M = {}

M.files = {}

M.find_files = function(skip)
  local scan = require('plenary.scandir')
  M.files = scan.scan_dir('.', {
    respect_gitignore = true,
  })

  M.files = vim.tbl_filter(function(f)
    for _, entry in pairs(skip) do
      -- TODO: Look into plenary.filetype
      if string.find(f, '.md', -3, true) == nil then
        return false
      end

      if f == entry then
        return false
      end
    end
    return true
  end, M.files)
end

return M

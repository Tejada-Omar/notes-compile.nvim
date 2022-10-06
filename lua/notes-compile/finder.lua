local scan = require('plenary.scandir')

local M = {}

local files

M.find_files = function (skip)
  -- local files = scan.scan_dir(vim.fn.getcwd(), {
  files = scan.scan_dir(vim.loop.cwd(), {
    respect_gitignore = true,
    search_patten = '*.md'
  })

  files = vim.tbl_filter(function (f)
    for _, entry in pairs(skip) do
      if f == entry then
        return false
      end
    end
    return true
  end, files)
end

return M

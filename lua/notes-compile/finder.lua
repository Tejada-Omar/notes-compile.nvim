local scan = require('plenary.scandir')

local M = {}

local files

M.find_files = function (skip)
  -- Use ripgrep instead :(
  local scan = require('plenary.scandir')
  -- files = scan.scan_dir(vim.loop.cwd(), {
  files = scan.scan_dir('.', {
    respect_gitignore = true,
  })

  files = vim.tbl_filter(function (f)
    for _, entry in pairs(skip) do
      -- Look into plenary.filetype
      if string.find(f, '.md', -3, true) == nil then
        return false
      end

      if f == entry then
        return false
      end
    end
    return true
  end, files)
  P(files)
end

M.compile = function (file_name, args)
  local job = require('plenary.job')
  job:new({
    command = 'pandoc',
    args = {'-o', file_name, unpack(args), unpack(files)}
  }):start()
    -- args = {'-o', file_name, table.unpack(args), table.unpack(files)}
  -- vim.fn.jobstart({'pandoc', '-o', new_file_name, table.unpack(opts)}, {
  --   stdout_buffered = true
  -- })
end

return M

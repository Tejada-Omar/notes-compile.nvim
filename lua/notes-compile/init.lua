local config = require('notes-compile.config')
local finder = require('notes-compile.finder')
local processes = require('notes-compile.processes')

local M = {}

local setup_complete = false

-- TODO: Look into compile calling setup if not already setup
M.compile = function ()
  finder.find_files(config.opt.skip) -- TODO: Memoize filenames
  processes.run(config.opt.file_name, config.args, finder.files)
end

M.setup = function (opts)
  if setup_complete then return end
  config.setup(opts)

  setup_complete = true
end

return M

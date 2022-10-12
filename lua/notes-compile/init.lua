local config = require('notes-compile.config')
local finder = require('notes-compile.finder')
local processes = require('notes-compile.processes')

local M = {}

local setup_complete = false

M.compile = function ()
  finder.find_files(config.opt.skip) -- TODO: Memoize filenames
  processes.run(config.opt.file_name, config.args, finder.files)
end

M.setup = function (opts)
  if setup_complete then return end
  config.setup(opts)

  vim.api.nvim_create_user_command('CompileNotes', M.compile,
    {desc = 'Search in current working directory and compile notes'})

  setup_complete = true
end

return M

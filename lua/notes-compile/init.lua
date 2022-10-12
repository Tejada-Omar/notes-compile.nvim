local config = require('notes-compile.config')
local finder = require('notes-compile.finder')

local M = {}

local setup_complete = false

M.compile = function ()
  finder.find_files(config.opt.skip)
  finder.compile(config.opt.file_name, config.args)
end

M.setup = function (opts)
  if setup_complete then return end
  config.setup(opts)

  vim.api.nvim_create_user_command('CompileNotes', M.compile,
    {desc = 'Search in current working directory and compile notes'})

  setup_complete = true
end

return M

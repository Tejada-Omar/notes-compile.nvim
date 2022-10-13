local config = require('notes-compile.config')
local finder = require('notes-compile.finder')
local processes = require('notes-compile.processes')

local M = {}

local setup_complete = false
local autocmd_enabled = false

M.toggle_autocmd = function (event)
  if autocmd_enabled then
    vim.api.nvim_del_augroup_by_name('notes-compile')
    autocmd_enabled = false
    return
  end

  vim.api.nvim_create_augroup('notes-compile', {})
  vim.api.nvim_create_autocmd(event, {
    group = 'notes-compile',
    buffer = 0,
    desc = 'Begin autocompilation of notes',
    callback = function ()
      M.compile()
    end
  })

  autocmd_enabled = true
end

M.compile = function ()
  M.setup()
  finder.find_files(config.opt.skip)
  processes.run(config.opt.file_name, config.args, finder.files)
end

M.setup = function (opts)
  if setup_complete then return end
  config.setup(opts)

  setup_complete = true
end

return M

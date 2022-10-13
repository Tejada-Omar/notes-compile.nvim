local config = require('notes-compile.config')
local finder = require('notes-compile.finder')
local processes = require('notes-compile.processes')

local M = {}

local setup_complete = false
-- Table in form enabled_autocmds[event] = 'related autocmd id'
local enabled_autocmds = {}

M.toggle_autocmd = function (args)
  local events = (not vim.tbl_isempty(args.fargs)) and args.fargs or {'BufWritePost'}

  vim.api.nvim_create_augroup('notes-compile', {clear = false})
  for _, event in pairs(events) do
    if vim.tbl_contains(vim.tbl_keys(enabled_autocmds), event) then
      vim.api.nvim_del_autocmd(enabled_autocmds[event])
      enabled_autocmds[event] = nil
      goto continue
    end

    local id = vim.api.nvim_create_autocmd(event, {
      group = 'notes-compile',
      buffer = 0,
      desc = 'Begin autocompilation of notes',
      callback = function ()
        M.compile()
      end
    })
    enabled_autocmds[event] = id

    ::continue::
  end
end

M.turnoff_autocmd = function ()
  vim.api.nvim_create_augroup('notes-compile', {clear = true})
  enabled_autocmds = {}
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

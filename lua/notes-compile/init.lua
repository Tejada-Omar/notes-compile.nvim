local config = require('notes-compile.config')
local finder = require('notes-compile.finder')
local processes = require('notes-compile.processes')

local M = {}

local setup_complete = false
-- Table in form enabled_autocmds[event] = 'related autocmd id'
local enabled_autocmds = {}

local _change_autocmd = function (fargs, callback)
  local events = (not vim.tbl_isempty(fargs)) and fargs or {'BufWritePost'}

  for _, event in pairs(events) do
    if vim.tbl_contains(vim.tbl_keys(enabled_autocmds), event) then
      if callback ~= nil then callback(event) end
      goto continue
    end

    local id = vim.api.nvim_create_autocmd(event, {
      group = 'notes-compile',
      buffer = 0,
      callback = function ()
        M.compile()
      end
    })
    enabled_autocmds[event] = id

    ::continue::
  end
end

M.toggle_autocmd = function (args)
  vim.api.nvim_create_augroup('notes-compile', {clear = false})
  _change_autocmd(args.fargs, function (event)
    vim.api.nvim_del_autocmd(enabled_autocmds[event])
    enabled_autocmds[event] = nil
  end)
end

M.turnoff_autocmd = function ()
  vim.api.nvim_create_augroup('notes-compile', {clear = true})
  enabled_autocmds = {}
end

M.turnon_autocmd = function (args)
  vim.api.nvim_create_augroup('notes-compile', {clear = false})
  _change_autocmd(args.fargs, nil)
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

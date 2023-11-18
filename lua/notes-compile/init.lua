local config = require('notes-compile.config')
local finder = require('notes-compile.finder')
local processes = require('notes-compile.processes')

local M = {}

local setup_complete = false
-- Table in form enabled_autocmds[event] = 'related autocmd id'
local enabled_autocmds = {}
local augroup_name = 'notes-compile'

-- local _change_autocmd = function(fargs, callback)
local function _change_autocmd(fargs, callback)
  local events = (not vim.tbl_isempty(fargs)) and fargs or { 'BufWritePost' }

  for _, event in pairs(events) do
    if vim.tbl_contains(vim.tbl_keys(enabled_autocmds), event) then
      if callback ~= nil then callback(event) end
      goto continue
    end

    local id = vim.api.nvim_create_autocmd(event, {
      group = augroup_name,
      buffer = 0,
      callback = function() M.compile() end,
    })
    enabled_autocmds[event] = id

    ::continue::
  end
end

M.toggle_autocmd = function(args)
  vim.api.nvim_create_augroup(augroup_name, { clear = false })
  _change_autocmd(args.fargs, function(event)
    vim.api.nvim_del_autocmd(enabled_autocmds[event])
    enabled_autocmds[event] = nil
  end)
end

M.turnoff_autocmd = function()
  vim.api.nvim_create_augroup(augroup_name, { clear = true })
  enabled_autocmds = {}
end

M.turnon_autocmd = function(args)
  vim.api.nvim_create_augroup(augroup_name, { clear = false })
  _change_autocmd(args.fargs, nil)
end

M.print_attached_events = function()
  print(augroup_name .. ' attached to following events')
  vim.pretty_print(vim.tbl_keys(enabled_autocmds))
end

M.compile = function()
  M.setup()
  finder.find_files(config.opt.skip)
  processes.run(
    config.opt.file_name,
    config.args,
    finder.files,
    config.opt.zathura_integration
  )
end

M.setup = function(opts)
  if setup_complete then return end
  config.setup(opts)

  if not vim.tbl_isempty(config.opt.events) then
    M.turnon_autocmd { fargs = config.opt.events }
  end

  setup_complete = true
end

return M

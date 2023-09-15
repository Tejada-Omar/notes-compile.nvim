local Job = require('plenary.job')

local M = {}

local _compile_job = function(file_name, args, files)
  local pandoc_args = vim.list_extend({ '-o', file_name }, args)
  pandoc_args = vim.list_extend(pandoc_args, files)
---@diagnostic disable-next-line: missing-fields
  return Job:new {
    command = 'pandoc',
    args = pandoc_args,
    on_stderr = function(error, data)
      print(error)
      print(data)
    end,
  }
end

local _is_zathura_running_job = function()
---@diagnostic disable-next-line: missing-fields
  return Job:new {
    command = 'pgrep',
    args = { 'zathura', '-c' },
  }
end

-- TODO: Look into customizing pdf viewer
local _open_zathura_job = function(file_name)
---@diagnostic disable-next-line: missing-fields
  return Job:new {
    command = 'zathura',
    args = { file_name },
    detached = true,
  }
end

M.run = function(file_name, args, files, pandoc_integration)
  -- TODO: Create version that doesn't open zathura for BufWritePost
  local compile_job = _compile_job(file_name, args, files)
  local is_zathura_running_job = _is_zathura_running_job()
  local open_zathura_job = _open_zathura_job(file_name)

  if pandoc_integration == true then
    compile_job:and_then_wrap(is_zathura_running_job)
    is_zathura_running_job:and_then_on_failure_wrap(open_zathura_job)
  end

  compile_job:start()
end

return M

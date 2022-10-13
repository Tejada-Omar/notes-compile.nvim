if vim.g.loaded_nvim_compile == 1 then
  return
end
vim.g.loaded_nvim_compile = 1

vim.api.nvim_create_user_command('CompileNotes', require('notes-compile').compile,
  {desc = 'Search in current working directory and compile notes'})

vim.api.nvim_create_user_command('CompileNotesAutoToggle', require('notes-compile').toggle_autocmd, {
  nargs = '*',
  desc = 'Toggle autocmd to begin compilation on event'
})

vim.api.nvim_create_user_command('CompileNotesTurnOff', require('notes-compile').turnoff_autocmd,
  {desc = 'Turn off all autocmds'})

vim.api.nvim_create_user_command('CompileNotesTurnOn', require('notes-compile').turnon_autocmd, {
  nargs = '*',
  desc = 'Turn on autocmd to begin compilation on event'
})

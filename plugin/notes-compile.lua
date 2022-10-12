if vim.g.loaded_nvim_compile == 1 then
  return
end
vim.g.loaded_nvim_compile = 1

vim.api.nvim_create_user_command('CompileNotes', require('notes-compile').compile,
  {desc = 'Search in current working directory and compile notes'})

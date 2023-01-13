# notes-compile.nvim

**WORK IN PROGRESS**

A Neovim plugin to compile notes into pdf by recursively searching in your
current working directory for markdown files and opening them in zathura

## Getting Started

### Dependencies

- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [pandoc](https://pandoc.org/)
- [zathura](https://pwmt.org/projects/zathura/) (optional)

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'Tejada-Omar/notes-compile.nvim',
  requires = { 'nvim-lua/plenary.nvim' }
}
```

## Customization

### No Configuation

```lua
require('notes-compile').setup()
```

### Default Configuration

```lua
require('notes-compile').setup {
  file_name = 'master.pdf',
  skip = { 'readme.md' },
  events = {},
  pandoc_args = {
    '--toc',
    '-N',
    -- Table to represent '-V KEY[=VAL]'
    { '-V', 'documentclass:extarticle' },
    { '-V', 'geometry:margin=1cm' },
    { '-V', 'fontsize=14pt' }
  },
  zathura_integration = false,
}
```

## User Commands

> Note that autocmds are automatically placed in augroup `notes-compile`


|           Event            |                           Description                            |
|:--------------------------:|:----------------------------------------------------------------:|
|       `NotesCompile`       |       Compile all markdown notes in `cwd` and open zathura       |
|    `NotesCompileToggle`    | Toggle **on/off** autocmd for event(s) (default: `BufWritePost`) |
|   `NotesCompileToggleOn`   |   Toggle **on** autocmd for event(s) (default: `BufWritePost`)   |
|  `NotesCompileToggleOff`   |                   Toggle **off** all autocmds                    |
| `NotesCompileShowAttached` |                      Prints attached events                      |

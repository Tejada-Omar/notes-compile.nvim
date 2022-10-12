# notes-compile.nvim

**WORK IN PROGRESS**

A Neovim plugin to compile notes into pdf by recursively searching in your
current working directory for markdown files and opening them in zathura

## Getting Started

### Dependencies

- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [pwmt/zathura](https://pwmt.org/projects/zathura/)

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'Tejada-Omar/notes-compile.nvim',
  requires = {'nvim-lua/plenary.nvim'}
}
```

## Customization

### Default Configuration

```lua
require('notes-compile').setup {
  file_name = 'master.pdf'
  skip = { 'readme.md' },
  pandoc_args = {
    cmd_args = { '--toc', '-N' },
    format = {
      documentclass = 'extarticle',
      margin = '1cm',
      fontsize = '14pt'
    }
  }
}
```

### Starting notes-compile

```lua
require('notes-compile').setup()
```

### Manual Compilation

If you want to manually begin compiling your notes, you can do so with:

```lua
require('notes-compile').compile()
```

## Vim Commands

notes-compile user commands:


|     Event      |                     Description                      |
|:--------------:|:----------------------------------------------------:|
| `CompileNotes` | Compile all markdown notes in `cwd` and open zathura |

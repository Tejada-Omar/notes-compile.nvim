local stub = require('luassert.stub')

-- local defaults = {
--   file_name = 'master.pdf',
--   skip = { 'readme.md' },
--   events = {},
--   pandoc_args = {
--     '--toc',
--     '-N',
--     { '-V', 'documentclass:extarticle' },
--     { '-V', 'geometry:margin=1cm' },
--     { '-V', 'fontsize=14pt' }
--   }
-- }

describe('parsing arguments', function ()
  local config = require('notes-compile.config')

  it('should format arguments', function ()
    config.opt = {
      pandoc_args = {
        '--toc',
        '-N',
        { '-V', 'documentclass:extarticle' },
        { '-V', 'geometry:margin=1cm' },
        { '-V', 'fontsize=14pt' }
      }
    }

    local proper_args = {
      '--toc',
      '-N',
      '-V',
      'documentclass:extarticle',
      '-V',
      'geometry:margin=1cm',
      '-V',
      'fontsize=14pt'
    }

    config.get_ready_args()
    assert.are.same(proper_args, config.args)
  end)

  it('should plain insert strings', function()
    config.opt = {
      pandoc_args = {
        '--toc',
        '-N'
      }
    }

    local proper_args = { '--toc', '-N' }

    config.get_ready_args()
    assert.are.same(proper_args, config.args)
  end)

  it('should append items in table', function ()
    config.opt = {
      pandoc_args = {
        { '-V', 'documentclass:extarticle' },
        { '-V', 'geometry:margin=1cm' },
        { '-V', 'fontsize=14pt' }
      }
    }

    local proper_args = {
      '-V',
      'documentclass:extarticle',
      '-V',
      'geometry:margin=1cm',
      '-V',
      'fontsize=14pt'
    }

    config.get_ready_args()
    assert.are.same(proper_args, config.args)
  end)

  it('should skip over invalid entrys', function ()
    config.opt = {
      pandoc_args = {
        function() return "shouldn't appear" end
      }
    }

    config.get_ready_args()
    assert.are.same({}, config.args)
  end)

  it('errors when modifying frozen table', function ()
    config.setup()
    assert.has_error(function() config.args.pandoc_args = {} end)
  end)
end)

describe('merge new options', function ()
  local config = require('notes-compile.config')

  before_each(function ()
    stub(config, 'get_ready_args')
  end)

  after_each(function ()
    config.get_ready_args:revert()
  end)

  it('should replace strings', function ()
    local file_name = 'test.pdf'
    config.setup { file_name = file_name }
    assert.are.equal(file_name, config.opt.file_name)
  end)

  it('should replace tables', function ()
    local skip = { 'readme.md' }
    config.setup { skip = skip }
    assert.are.same(skip, config.opt.skip)
  end)

  it('should replace nested tables', function ()
    local pandoc_args = { { '-d', 'example_file.yml' } }
    config.setup { pandoc_args = pandoc_args }
    assert.are.same(pandoc_args, config.opt.pandoc_args)
  end)

  it('should delete options', function ()
    local pandoc_args = {}
    config.setup { pandoc_args = pandoc_args }
    assert.are.same(pandoc_args, config.opt.pandoc_args)
  end)

  it('errors when modifying frozen table', function ()
    config.setup()
    assert.has_error(function() config.opt.file_name = 'error.md' end)
  end)
end)

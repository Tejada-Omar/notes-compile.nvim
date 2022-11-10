local notes = require('notes-compile.init')
local augroup_name = 'notes-compile'

local get_autocmds = function(...)
  return vim.api.nvim_get_autocmds {
    group = augroup_name,
    event = ...,
  }
end

local get_all_events = function(autocmds)
  local events = {}
  for _, event in pairs(autocmds) do
    table.insert(events, event.event)
  end

  return events
end

describe('turning on autocmds', function()
  before_each(function() notes.turnoff_autocmd() end)

  it('no args should turn on BufWritePost', function()
    notes.turnon_autocmd { fargs = {} }
    assert.are.same({ 'BufWritePost' }, get_all_events(get_autocmds()))
  end)

  it('given args should turn on event', function()
    notes.turnon_autocmd { fargs = { 'BufWritePre' } }
    assert.are.same({ 'BufWritePre' }, get_all_events(get_autocmds()))
  end)

  it('turning on multiple times should keep event on', function()
    notes.turnon_autocmd { fargs = {} }
    notes.turnon_autocmd { fargs = {} }
    assert.are.same({ 'BufWritePost' }, get_all_events(get_autocmds()))
  end)

  it('multiple args should turn on multiple events', function()
    notes.turnon_autocmd { fargs = { 'BufWritePre', 'WinLeave' } }
    assert.are.same(
      { 'BufWritePre', 'WinLeave' },
      get_all_events(get_autocmds())
    )
  end)
end)

describe('turning off autocmds', function()
  before_each(function() notes.turnoff_autocmd() end)

  it('should turn off all', function()
    notes.turnon_autocmd { fargs = {} }
    notes.turnoff_autocmd()
    assert.are.same({}, get_all_events(get_autocmds()))
  end)

  it('should clear multiple times', function()
    notes.turnoff_autocmd()
    assert.has_no.error(function() notes.turnoff_autocmd() end)
    assert.are.same({}, get_all_events(get_autocmds()))
  end)

  it('should clear multiple times', function()
    notes.turnon_autocmd { fargs = { 'BufWritePre', 'WinLeave' } }
    notes.turnoff_autocmd()
    assert.are.same({}, get_all_events(get_autocmds()))
  end)
end)

describe('toggling autocmds', function()
  before_each(function() notes.turnoff_autocmd() end)

  it('no args should toggle BufWritePost', function()
    notes.toggle_autocmd { fargs = {} }
    assert.are.same({ 'BufWritePost' }, get_all_events(get_autocmds()))

    notes.toggle_autocmd { fargs = {} }
    assert.are.same({}, get_all_events(get_autocmds()))
  end)

  it('given args should toggle event', function()
    notes.toggle_autocmd { fargs = { 'BufWritePre' } }
    assert.are.same({ 'BufWritePre' }, get_all_events(get_autocmds()))

    notes.toggle_autocmd { fargs = { 'BufWritePre' } }
    assert.are.same({}, get_all_events(get_autocmds()))
  end)

  it('multiple args should toggle multiple events', function()
    notes.toggle_autocmd { fargs = { 'BufWritePre', 'WinLeave' } }
    assert.are.same(
      { 'BufWritePre', 'WinLeave' },
      get_all_events(get_autocmds())
    )

    notes.toggle_autocmd { fargs = { 'BufWritePre', 'WinLeave' } }
    assert.are.same({}, get_all_events(get_autocmds()))
  end)
end)

describe('setup', function()
  before_each(function() notes.turnoff_autocmd() end)

  it('should turn on events passed in config', function()
    notes.setup { events = { 'BufWritePre' } }
    assert.are.same({ 'BufWritePre' }, get_all_events(get_autocmds()))
  end)
end)

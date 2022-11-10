local mock = require("luassert.mock")

describe("markdown files", function()
  local finder = require("notes-compile.finder")

  before_each(function()
    local scan = mock(require("plenary.scandir"), true)
    scan.scan_dir.returns({
      "./doc/notes-compile.txt",
      "./doc/tags",
      "./lua/notes-compile/init.lua",
      "./tests/playground/a.md",
      "./tests/playground/master.pdf",
    })
  end)

  after_each(function()
    mock.revert(require("plenary.scandir"))
  end)

  it("should filter for markdown files", function()
    finder.find_files({})
    assert.are.same({ "./tests/playground/a.md" }, finder.files)
  end)

  it("should skip over passed in files", function()
    finder.find_files({ "./tests/playground/a.md" })
    assert.are.same({}, finder.files)
  end)

  it("should only skip relevant files", function()
    finder.find_files({ "./doc/tags" })
    assert.are.same({ "./tests/playground/a.md" }, finder.files)
  end)

  it("shouldn't skip if nil passed", function()
    finder.find_files()
    assert.are.same({ "./tests/playground/a.md" }, finder.files)
  end)

  it("shouldn't skip if empty table passed", function()
    finder.find_files({})
    assert.are.same({ "./tests/playground/a.md" }, finder.files)
  end)
end)

describe("nothing present", function()
  local finder = require("notes-compile.finder")
  before_each(function()
    local scan = mock(require("plenary.scandir"), true)
    scan.scan_dir.returns({})
  end)

  after_each(function()
    mock.revert(require("plenary.scandir"))
  end)

  it("should return nothing if none found", function()
    finder.find_files()
    assert.are.same({}, finder.files)
  end)
end)

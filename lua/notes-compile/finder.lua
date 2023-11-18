local M = {}

M.files = {}

M.find_files = function(skip)
  local scan = require('plenary.scandir')
  M.files = scan.scan_dir('.', {
    respect_gitignore = true,
  })

  M.files = vim.tbl_filter(function(f)
    if skip == nil or vim.tbl_isempty(skip) then
      if string.find(f, '.md', -3, true) == nil then return false end
      return true
    end

    for _, entry in pairs(skip) do
      if f == entry then
        return false
      elseif string.find(f, '.md', -3, true) == nil then
        return false
      end
    end

    return true
  end, M.files)

  table.sort(M.files, function(f1, f2)
    local function digit_len(num)
      return ('%04d%s'):format(#num, num)
    end
    return f1:gsub('%d+', digit_len) < f2:gsub('%d+', digit_len)
  end)
end

return M

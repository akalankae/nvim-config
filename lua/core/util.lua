--==============================================================================
--                      Utility Functions
--==============================================================================

local Utils = {}

-- Map "lhs" keystrokes to "rhs" keystrokes, non-recurively
-- normal mode
function Utils.Nnoremap(lhs, rhs, opts)
  opts = vim.tbl_extend("keep", { remap = false }, opts or {})
  vim.keymap.set("n", lhs, rhs, opts)
end

-- insert mode
function Utils.Inoremap(lhs, rhs, opts)
  opts = vim.tbl_extend("keep", { remap = false }, opts or {})
  vim.keymap.set("i", lhs, rhs, opts)
end

-- visual mode
function Utils.Vnoremap(lhs, rhs, opts)
  opts = vim.tbl_extend("keep", { remap = false }, opts or {})
  vim.keymap.set("v", lhs, rhs, opts)
end

local function split(str, delim)
  delim = delim or "%s"
  return string.gmatch(str, string.format("[^%s]+", delim))
end

local function include_paths(fname)
  local paths = string.gsub(package.path, "%?", fname)
  for path in split(paths, "%;") do
    if vim.fn.filereadable(path) then
      return path
    end
  end
end

local function include_rtpaths(fname)
  local rtpaths = vim.api.nvim_list_runtime_paths()
  local modfile = string.format("%s.lua", fname)
  for _, rtpath in ipairs(rtpaths) do
    local path = table.concat({ rtpath, "lua", modfile }, "/") -- lua/*.lua
    if vim.fn.filereadable(path) then
      return path
    end
    path = table.concat({ rtpath, "lua", fname, "init.lua" }) -- lua/*/init.lua
    if vim.fn.filereadable(path) then
      return path
    end
  end
end

function Utils.FindRequiredPath(module)
  local fname = vim.fn.substitute(module, "\\.", "/", "g")
  local f = include_paths(fname)
  if f then
    return f
  end
  f = include_rtpaths(fname)
  if f then
    return f
  end
end

return Utils

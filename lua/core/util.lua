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

-- Update the last modification time
-- Look for "Last Modified" in first N rows (8), update when file is re-saved.
-- NOTE: If you do not use MIN_NUM_LINES, when this file is saved it will update
-- the string "Last Modified: " on line 82 :)
function Utils.UpdateLastModifiedTime()
  local MIN_NUM_LINES = 8 -- skip files that do not have at least this many lines
  local num_lines = vim.fn.line("$")
  local bufnr = vim.api.nvim_get_current_buf()
  if num_lines < MIN_NUM_LINES then
    return
  end
  if vim.api.nvim_buf_get_option(bufnr, "modifiable") then
    local time = os.date("%d %b %y %I.%M %p")
    for i = 1, MIN_NUM_LINES do
      local line = vim.fn.getline(i)
      local replacement = vim.fn.substitute(line, "Last Modified: \\zs.*", time, "c")
      if replacement ~= line then
        vim.fn.setline(i, replacement)
        vim.notify(vim.fn.expand("<afile>") .. " was modified at " .. time)
        break
      end
    end
  else
    vim.notify(vim.fn.expand("<afile>") .. " is not modifiable")
  end
end

-- Insert file name & created date
-- Relevant skeleton file is sourced and file name and created date inserted in to the
-- designated line when file is created.
-- WARNING: "modifiable" flag is not checked, so use for above reason only
function Utils.UpdateSkeletonFile()
  local time = os.date("%d %b %y")
  for i = 1, vim.fn.line("$") do
    vim.fn.setline(i, vim.fn.substitute(vim.fn.getline(i), "Created on: \\zs.*", time, "c"))
    vim.fn.setline(i, vim.fn.substitute(vim.fn.getline(i), "File name: \\zs.*", vim.fn.expand("<afile>"), "c"))
  end
end

return Utils

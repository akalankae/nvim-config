--==============================================================================
-- Neovim Stable Edtion (version 0.8)
-- Lua configuration: autocommands
--==============================================================================

local opts = { clear = true }
local CreateAutocmd = vim.api.nvim_create_autocmd
local CreateAugroup = vim.api.nvim_create_augroup

--=============================================================================
-- Line Numbers
--=============================================================================
-- Toggle/untoggle relative/absolute line numbers depending on active/inactive
-- state of the buffers.
local toggle_ln = CreateAugroup("NumberToggle", opts)

-- relative line numbers in active buffer
CreateAutocmd(
  { "BufEnter", "FocusGained", "InsertLeave" },
  { pattern = "*", command = "set relativenumber", group = toggle_ln }
)

-- absolute line numbers in inactive buffer
CreateAutocmd(
  { "BufLeave", "FocusLost", "InsertEnter" },
  { pattern = "*", command = "set norelativenumber", group = toggle_ln }
)

--=============================================================================
-- Customize Auto-pairs
--=============================================================================
-- Make AutoPairs understand python F-strings & byte strings
CreateAutocmd("FileType", {
  pattern = "python",
  command = [[ let b:AutoPairs = AutoPairsDefine({ "f'": "'", "b'": "'", "r'": "'"}) ]]
})

-- AutoPairs for rust
CreateAutocmd("FileType", {
  pattern = "rust",
  command = [[ let b:AutoPairs = AutoPairsDefine({ 'r#"': '"#', "\w\zs<": ">", "|": "|"}) ]]
})

-- Make AutoPairs understand markup language angle brackets
CreateAutocmd("FileType", {
  pattern = { "html", "xml" },
  command = [[  let b:AutoPairs = AutoPairsDefine({ '<': '>' }) ]]
})

-- Auto-complete HTML tags with omnicomplete
CreateAutocmd("FileType", {
  pattern = "html",
  -- command = "inoremap </ </<C-x><C-o>",
  callback = function() vim.keymap.set("i", "</", "</<C-x><C-o>") end,
})

-- Auto pairs for ruby
CreateAutocmd("FileType", {
  pattern = "ruby",
  command = [[ let b:AutoPairs = AutoPairsDefine({"|": "|"}) ]]
})

--=============================================================================
-- Source Skeleton Files (templates) for Coding
--=============================================================================

local skeleton_dir = vim.fn.stdpath("config") .. "/skeletons/"

-- shellscript
CreateAutocmd("BufNewFile", {
  pattern = "*.sh",
  callback = function()
    vim.cmd("0read " .. skeleton_dir .. "skeleton.sh")
    require("core.util").UpdateSkeletonFile()
  end
})

-- python
CreateAutocmd("BufNewFile", {
  pattern = "*.py",
  callback = function()
    vim.cmd("0read " .. skeleton_dir .. "skeleton.py")
    require("core.util").UpdateSkeletonFile()
  end
})

-- C
CreateAutocmd("BufNewFile", {
  pattern = "*.c",
  callback = function()
    vim.cmd("0read " .. skeleton_dir .. "skeleton.c")
    require("core.util").UpdateSkeletonFile()
  end
})

-- lua
CreateAutocmd("BufNewFile", {
  pattern = "*.lua",
  callback = function()
    vim.cmd("0read " .. skeleton_dir .. "skeleton.lua")
    require("core.util").UpdateSkeletonFile()
  end
})

-- HTML
CreateAutocmd("BufNewFile", {
  pattern = "*.html",
  command = "0read " .. skeleton_dir .. "skeleton.html",
})

-- go
CreateAutocmd("BufNewFile", {
  pattern = "*.go",
  command = "0read " .. skeleton_dir .. "skeleton.go",
})

-- ruby
CreateAutocmd("BufNewFile", {
  pattern = "*.rb",
  command = "0read " .. skeleton_dir .. "skeleton.rb",
})

-- AUTO-PAIRS "FLY-MODE"
-- Auto-pairs "Fly Mode" enables jumping out of nested closed pairs easier.
-- Works for ), ] &  }. Instead of inserting parentheses.
-- Press "g:AutoPairsBackInsert" key (default <M-b>) to jump back
-- and insert closed pair.
--
-- WHY AN AUTOCOMMAND? WHY NOT A CONFIGURATION FILE?
-- Before we setup config for "auto-pairs", we need to test if "auto-pairs" is
-- installed. The way to check this is using global table "packer_plugin".
-- But this table is only visible after "packer_compiled.lua" is loaded, which
-- it turns out is AFTER user config (init.lua) is sourced, BUT before VimEnter
-- autocommands are executed. Therefore, this will not work in a config file.
-- UPDATE: using lazy.nvim instead of packer.nvim as plugin manager
-- CreateAutocmd("VimEnter", {
--   desc = "Register auto-pairs Fly Mode to activate",
--   pattern = "*",
--   callback = function()
--     local lazy = require("lazy")
--     if not vim.tbl_isempty(lazy) and vim.tbl_contains(vim.tbl_map(
--           function(plugin)
--             return plugin.name
--           end,
--           lazy.plugins()), "auto-pairs") then
--       vim.g.AutoPairsFlyMode = 1
--       vim.g.AutoPairsShortcutBackInsert = "<C-b>"
--     end
--   end,
--   group = CreateAugroup("ActivateAutoPairsFlyMode", opts),
-- })

--=============================================================================
-- Restore Cursor Position
--=============================================================================
-- move cursor to where it was the last time in the file
-- source: https://builtin.com/software-engineering-perspectives/neovim-configuration
CreateAutocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd([[ execute  "normal! g'\"" ]])
    end
  end,
})

-- Update last modified timestamp of source files
CreateAutocmd("BufWritePre", {
  pattern = { "*.py", "*.c", "*.lua", "*.sh" },
  callback = function()
    require("core.util").UpdateLastModifiedTime()
  end
})

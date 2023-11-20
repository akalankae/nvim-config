--==============================================================================
--                          Keymappings
--==============================================================================
local util = require('core.util')

local Nnoremap = util.Nnoremap
local Inoremap = util.Inoremap
local Vnoremap = util.Vnoremap

-- Setup global LEADER key
vim.g.mapleader = ";"

-- Close window with ctrl-q
Nnoremap("<C-q>", "<C-w>q")

-- Ctrl-s to save in NORMAL & INSERT modes, and return to relevant mode
Nnoremap("<C-s>", "<Cmd>update<CR>", { desc = "write buffer if modified" })
Inoremap("<C-s>", "<Esc><Cmd>update<CR>a", { desc = "write buffer if modified" })

-- Easy navigation between splits
Nnoremap("<C-l>", "<C-w>l") --> Goto split on left
Nnoremap("<C-h>", "<C-w>h") --> Goto split on right
Nnoremap("<C-j>", "<C-w>j") --> Goto split below
Nnoremap("<C-k>", "<C-w>k") --> Goto split above

-- * Transform a horizontal split to a vertical split (e.g. help pages)
-- NOTE: Assumes command is launched from a vertical split below first window
Nnoremap("<Leader>hv", "<C-w>t<C-w>H<C-w>l")
-- * Transform a vertical split to a horizontal split
-- NOTE: Assumes command is run from a horizontal split to right of first one
Nnoremap("<Leader>vh", "<C-w>t<C-w>K<C-w>j")

-- Clear currently highlighted text with <Escape> key
Nnoremap("<Esc>", "<cmd>nohlsearch<Bar>:echo<CR>")

-- Source current buffer
Nnoremap("<M-s>", "<cmd>source %<cr>", { desc = "Source current file" })
Vnoremap("<M-s>", 'y<cmd>@"<cr>', { desc = "Source visual selection" })

-- In INSERT mode;
-- <C-u> deletes everything from cursor to the start of the line (UNDO LINE)
-- <C-w> deletes the word before the cursor (UNDO WORD),
Inoremap("<C-l>", "<Esc>viwUea") -- Captalize previous WORD

-- -- Map ":" in NORMAL mode to open a command-line window ready for work
-- nnoremap(":", "q:i")
Nnoremap("<C-c>", "<cmd>tabclose<cr>")
Nnoremap("gn", "<cmd>tabnext<cr>")     -- by default "gT"
Nnoremap("gp", "<cmd>tabprevious<cr>") -- by default "gT"

-- Go up/down the page, keeping cursor in the middle of the screen
-- credit to Primeagen
Nnoremap("<C-d>", "<C-d>zz")
Nnoremap("<C-u>", "<C-u>zz")

-- From "nvim-lua/kickstart.nvim"
-- Make j/k move up/down using "visual" lines instead of actual lines, even when
-- lines are wrapped with window splitting, when motion is not prepended by a
-- count (e.g. k, not with 10k). Uses gk/gj instead of k/j, respectively, when
-- a line count is not given.
local opts = { expr = true, silent = true }
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", opts)
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", opts)

-- Toggle & focus Nvim-Tree
Nnoremap("<Leader>tt", "<cmd>NvimTreeToggle<cr>")
Nnoremap("<Leader>tf", "<cmd>NvimTreeFocus<cr>")

local telescope = require("telescope.builtin")

local function Nnoremap(lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set("n", lhs, rhs, opts)
end

Nnoremap("<Leader>fs", telescope.live_grep, { desc = "[f]ind [s]tring" })
Nnoremap("<Leader>ff", telescope.find_files, { desc = "[f]ind [f]ile" })
Nnoremap("<Leader>fb", telescope.buffers, { desc = "[f]ind [b]buffers" })
Nnoremap("<Leader>fh", telescope.help_tags, { desc = "[f]ind [h]elp tags" })
Nnoremap("<Leader>fd", telescope.diagnostics, { desc = "[f]ind [d]iagnostic msgs" })
Nnoremap("<Leader>fc", telescope.colorscheme, { desc = "[f]ind [c]olorscheme" })

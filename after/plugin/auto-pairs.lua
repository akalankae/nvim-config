-- auto-pairs is a vim plugin

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
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Activate auto-pairs Fly Mode",
  callback = function()
    local lazy = require("lazy")
    if not vim.tbl_isempty(lazy) and vim.tbl_contains(vim.tbl_map(
          function(plugin)
            return plugin.name
          end,
          lazy.plugins()), "auto-pairs") then
      vim.g.AutoPairsFlyMode = 1
      vim.g.AutoPairsShortcutBackInsert = "<C-b>"
    end
  end,
  group = vim.api.nvim_create_augroup("ActivateAutoPairsFlyMode", { clear = true }),
})

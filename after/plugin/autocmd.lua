-- autocommands

-- Not a great idea! Textwidth should not change with width of using
-- terminal
-- If terminal is not wide enough to show 2 panes side-by-side, lower the
-- textwidth
-- vim.api.nvim_create_autocmd("BufEnter", {
--     callback = function()
--         local info = vim.fn.getwininfo()
--         if #info <= 1 then
--             local width = math.floor((info[1].width - (2 * info[1].textoff) - 2) / 2)
--             if width < vim.o.textwidth then
--                 print("Adjusting textwidth from " .. vim.o.textwidth .. " to " .. width)
--                 vim.opt["textwidth"] = width
--                 vim.opt["colorcolumn"] = "+0"
--             end
--         end
--     end
-- }
-- )
--

--=============================================================================
-- Record and notify Colorscheme Change
-- Each time colorscheme is changed, record the new colorscheme in the file:
-- $XDG_CACHE_DIR/nvim/colorscheme.dat
--=============================================================================
local CreateAutocmd = vim.api.nvim_create_autocmd
local CreateAugroup = vim.api.nvim_create_augroup

CreateAutocmd("ColorScheme", {
  desc = "announce and record change of colorscheme",
  callback = function()
    -- local new_colorscheme = vim.fn.expand("<amatch>")
    vim.notify("Theme changed to " .. vim.g.colors_name,
      vim.log.levels.INFO, { title = "Colorscheme" })
    local file = io.open(vim.fn.stdpath("cache") .. "/colorscheme.dat", "w")
    if file ~= nil then
      file:write(vim.g.colors_name)
      file:close()
    end
  end,
  group = CreateAugroup("RecordThemeChange", { clear = true }),
})

-- CreateAutocmd("BufWritePre", {
--   desc = "Format buffer with Conform.nvim",
--   pattern = "*.py", -- check `formatters_by_ft` in conform.nvim @lua/plugins/init.lua
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
--   group = require("plugins.lsp.autocmd").format_on_save,
-- })

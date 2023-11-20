-- Restore last colorscheme from ~/.cache/nvim/colorscheme.dat
-- If above file not found fallback to default
-- Set light or dark color palette depending on time of the day
-- Light from 6.00 AM to 7.00 PM, Dark from 7.00 PM to 6.00 AM

DARK_ONLY_PALETTES = { "moonfly" }

-- color_palette: either "dark" or "light"
-- fallback_colorscheme: default colorscheme in case things do not workout
-- colorscheme_file: file to which last used colorscheme was saved
-- i.e. $XDG_CACHE_DIR/nvim/colorscheme.dat
local function pick_colorscheme(color_palette, fallback_colorscheme, colorscheme_file)
  fallback_colorscheme = fallback_colorscheme or "default"
  local last_colorscheme = fallback_colorscheme
  colorscheme_file = colorscheme_file or io.open(vim.fn.stdpath("cache") .. "/colorscheme.dat", "r")
  if colorscheme_file ~= nil then
    last_colorscheme = colorscheme_file:read("a")
    colorscheme_file:close()
  else
    vim.api.nvim_err_write("Could not find colorscheme data file")
  end
  if color_palette == "light" and vim.tbl_contains(DARK_ONLY_PALETTES, last_colorscheme) then
    last_colorscheme = fallback_colorscheme
  end
  return last_colorscheme
end

local hour_of_day = tonumber(vim.fn.strftime("%H"))

if hour_of_day < 19 and hour_of_day > 5 then
  vim.o.background = "light"
else
  vim.o.background = "dark"
end

vim.cmd("colorscheme " .. pick_colorscheme(vim.o.background, "PaperColor"))

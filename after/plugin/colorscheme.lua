-- Restore last colorscheme from ~/.cache/nvim/colorscheme.dat
-- If above file not found fallback to default
-- Set light or dark color palette depending on time of the day
-- Light from 6.00 AM to 8.00 PM, Dark from 8.00 PM to 6.00 AM

local SUNRISE_HOUR = 6
local SUNSET_HOUR = 20
local DEFAULT_COLORSCHEME = "PaperColor" -- need to have "light" and "dark" backgrounds
local COLORSCHEME_DB = vim.fn.stdpath("config") .. "/colorschemes.dat"
local LAST_COLORSCHEME_FILE = vim.fn.stdpath("cache") .. "/colorscheme.dat"

-- Get suitable alternative colorscheme with given background
-- If no alternative return `fallback`
-- NOTE: "kanagawa-*" & "catppuccin-*" only has either "light" or "dark"
-- variants. But "kanagawa" & "catppuccin" has both variants.
local function get_alternative_colorscheme(colorscheme, background, fallback)
  fallback = fallback or DEFAULT_COLORSCHEME
  if colorscheme:find("catppuccin") ~= nil then
    return "catppuccin"
  end
  if colorscheme:find("kanagawa") ~= nil then
    return "kanagawa"
  end
  if colorscheme:find("github") ~= nil then
    -- github_dimmed, github_dark_dimmed do not have light variants
    if colorscheme:find("dimmed") ~= nil then
      colorscheme = "github_dark"
    end
    local alt = { light = "dark", dark = "light" }
    local alternative_colorscheme = colorscheme:gsub(alt[background], background)
    if alternative_colorscheme ~= nil then
      return alternative_colorscheme
    end
  end
  return fallback
end

-- read colorscheme data file and check whether given background is supported
local function supports_background(colorscheme, background)
  local file = io.open(COLORSCHEME_DB)
  if file ~= nil then
    for line in file:lines() do
      local cs, bg1, bg2 = unpack(vim.fn.split(line))
      if cs == colorscheme then
        return bg1 == background or bg2 == background
      end
    end
    file:close()
  else
    vim.api.nvim_err_write("database file " .. COLORSCHEME_DB .. " not found")
  end
  vim.api.nvim_err_write(colorscheme .. " was not found in " .. COLORSCHEME_DB)
  return false
end

-- Pick "dark" or "light" background depending on time of the day
local function pick_background()
  local hour_of_day = tonumber(vim.fn.strftime("%H"))
  if hour_of_day > SUNRISE_HOUR and hour_of_day < SUNSET_HOUR then
    return "light"
  end
  return "dark"
end

-- background: either "dark" or "light"
-- fallback: default fallback colorscheme in case things do not workout
-- colorscheme_file: file to which last used colorscheme was saved
-- i.e. $XDG_CACHE_DIR/nvim/colorscheme.dat
local function pick_colorscheme(background, fallback, colorscheme_file)
  fallback = fallback or DEFAULT_COLORSCHEME
  colorscheme_file = colorscheme_file or io.open(LAST_COLORSCHEME_FILE, "r")
  local colorscheme = fallback
  if colorscheme_file ~= nil then
    colorscheme = colorscheme_file:read("a")
    colorscheme_file:close()
  else
    vim.api.nvim_err_write("Could not find colorscheme data file")
  end
  if not supports_background(colorscheme, background) then
    return get_alternative_colorscheme(colorscheme, background, fallback)
  end
  return colorscheme
end



local background = pick_background()
vim.o.background = background
vim.cmd("colorscheme " .. pick_colorscheme(background, "PaperColor"))

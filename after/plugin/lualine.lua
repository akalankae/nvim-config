-- Lualine config

-- Get name of active python virtual environment
-- If VIRTUAL_ENV is not a path name returns VIRTUAL_ENV
-- Else VIRTUAL_ENV variable is an absolute path that ends in ".venv" or "venv"
-- If virtual environment is not active return empty string
local function get_venv_name()
  local venv = os.getenv("VIRTUAL_ENV")
  local virtual_env_name = ""
  if venv ~= nil then
    for match in venv:gmatch("[^/]+") do
      if match:match(".?venv") == nil then
        virtual_env_name = match
      end
    end
  end
  return virtual_env_name
end

require("lualine").setup({
  sections = {
    lualine_c = {
      {
        get_venv_name,
        color = { gui = "bold,italic" },
        separator = "┃",
        cond = function() return vim.bo.filetype == "python" end,
      },
      "filename",
    },
  },
})

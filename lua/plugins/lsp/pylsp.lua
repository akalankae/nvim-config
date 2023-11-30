-- pylsp config
local M = {}

local python_path = vim.fn.exepath("python3")
local venv_path = os.getenv("VIRTUAL_ENV")

if venv_path ~= nil then
  python_path = venv_path .. "/bin/python"
end

M.configurationSources = {
  "pylint", "jedi", "rope", "black", "mypy"
}

M.plugins = {
  -- linters
  pylint = {
    enabled = true,
    executable = "pylint",
    args = { "--max-line-length=80" }
  },
  pyflakes = { enabled = false },
  pycodestyle = { enabled = false, ignore = { "W391" }, maxLineLength = 80 },

  -- autocompletion options
  jedi_completion = { fuzzy = true },

  -- import sorting
  pyls_isort = { enabled = false },

  -- type checker
  pylsp_mypy = {
    enabled = true,
    overrides = { "--python-executable", python_path, true },
    report_progress = true,
    live_mode = false,
  },

  -- formatter options
  black = { enabled = false, line_length = 80, skip_string_normalization = false },
  autopep8 = { enabled = false },
  yapf = { enabled = false },

  -- rope
  rope_autoimport = { enabled = true, completions = { enabled = true }, code_actions = { enabled = true }, memory = true },
  rope_completion = { enabled = true, eager = true },
  rope = { extensionModules = "", ropeFolder = {} },
}

return M

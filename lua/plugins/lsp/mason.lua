--==============================================================================
--                  Mason.nvim & Mason-lspconfig.nvim setup
--==============================================================================
-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
local lsp_zero = require("lsp-zero")

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "pyright" },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT"
            },
            diagnostics = {
              globals = { "vim"},
            },
            workspace = {
              library = {
                vim.fn.stdpath("config"),
              },
              checkThirdParty = false,
              maxPreload = 2000,
              preloadFileSize = 50000
            },
            telemetry = { enable = false },
            callSnippet = "Replace"
          }
        }
      })
    end
  }
})



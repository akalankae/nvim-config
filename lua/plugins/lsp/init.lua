--==============================================================================
--                          LSP setup
--==============================================================================
-- Order plugins are setup matters for mason,
-- (1) mason (2) mason-lspconfig (3) setup servers via lspconfig

local set_keymap = require "plugins.lsp.keymap"
local create_format_on_save_autocmd = require("plugins.lsp.autocmd").create_format_on_save_autocmd

local function on_attach(server, bufnr)
  set_keymap(server, bufnr)

  if server.server_capabilities.documentFormattingProvider then
    create_format_on_save_autocmd(server, bufnr)
    vim.notify(server.name .. " will format buffer " .. bufnr)
  else
    vim.notify(server.name .. " cannot format buffer " .. bufnr)
  end
end

local lspconfig = require "lspconfig"
local mason_lspconfig = require "mason-lspconfig"
local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities())

local server_configs = {
  lua_ls = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } }, -- shutup warning about unknown global
      workspace = {
        checkThirdParty = false,
        maxPreload = 2000,
        preloadFileSize = 50000,
        library = { vim.env.RUNTIME }, -- may add vim.stdpath('config'|'data')
      },
      telemetry = { enable = false },
      callSnippet = "Replace",
      format = { enable = true, defaultConfig = { quote_style = "double", trailing_tab_separator = "smart" } },
    }
  },

  bashls = {},

  pylsp = require "plugins.lsp.pylsp",

  clangd = {
    offsetEncoding = { "utf-16" },
  },

}

local handlers = {

  -- Default handler
  function(server)
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  -- Lua
  lua_ls = function()
    lspconfig.lua_ls.setup({
      settings = server_configs["lua_ls"],
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  -- Python
  pylsp = function()
    lspconfig.pylsp.setup({
      settings = server_configs["pylsp"],
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 200,
      },
    })
  end,

}

require("mason").setup()

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(server_configs),
  handlers = handlers,
})

--   warn =  
--   info =  
vim.fn.sign_define("DiagnosticSignError", { text = "🕱", texthl = "DiagnosticSignError", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", numhl = "" })

-- Configure diagnostic messages and the like
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  }
})

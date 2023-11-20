--=============================================================================
-- Auto-commands for LSP
--=============================================================================
local M = {}

function M.set_format_on_save(server, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    desc = server.name .. " formatting buffer " .. bufnr,
    group = vim.api.nvim_create_augroup("FormatOnSave", { clear=true }),
    callback = function(event)
      vim.lsp.buf.format({async=false})
      vim.notify(server.name .. " formatted " .. event.file)
    end,
  })

end

return M

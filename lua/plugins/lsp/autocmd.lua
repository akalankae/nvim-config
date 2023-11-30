--=============================================================================
-- Auto-commands for LSP
--=============================================================================
local M = {}

M.format_on_save = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

function M.set_format_on_save(server, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    desc = server.name .. " formatting buffer " .. bufnr,
    group = M.format_on_save,
    callback = function(event)
      vim.lsp.buf.format({ async = false })
      vim.notify(server.name .. " formatted " .. event.file)
    end,
  })
end

return M

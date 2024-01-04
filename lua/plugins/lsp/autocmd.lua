--=============================================================================
-- Auto-commands for LSP
--=============================================================================
local M = {}

M.format_on_save = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

function M.create_format_on_save_autocmd(server, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    desc = server.name .. " formatting buffer " .. bufnr,
    group = M.format_on_save,
    callback = function(event)
      vim.lsp.buf.format({
        async = false,
        format_options = { insertFinalNewline = true },
      })
      vim.notify(server.name .. " formatted " .. event.file)
    end,
  })
end

return M

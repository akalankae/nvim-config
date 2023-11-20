--=============================================================================
--                              Null-ls
--=============================================================================

local null_ls_ok, null_ls = pcall(require, "null-ls")

if not null_ls_ok then
    vim.notify("null-ls is not installed", vim.logs.levels.WARN,
        { title = "Null-ls Configuration" })
    return
end

local formatting = null_ls.builtins.formatting

local sources = {
    formatting.trim_newlines,
    formatting.trim_whitespace,
}


null_ls.setup({
    sources = sources,
})

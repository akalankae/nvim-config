local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require "cmp"
local luasnip = require "luasnip"
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lua" },
    {
      name = "luasnip",
      option = { use_show_condition = true, show_autosnippets = true }
    },
    { name = "nvim_lsp", keyword_length = 5 },
    { name = "buffer" },
    { name = "path" }
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- autoselect 1st
    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

    -- super tabs
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- Jump to next PLACEHOLDER in the snippet
    ["<C-j>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
        vim.notify("cannot jump to next placeholder", vim.log.levels.WARN,
          { title = "Auto Completions" })
      end
    end, { "i", "s" }),

    -- Jump to previous PLACEHOLDER in the snippet
    ["<C-k>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
        vim.notify("cannot jump to previous placeholder", vim.log.levels.WARN,
          { title = "Auto Completions" })
      end
    end, { "i", "s" }),
  }),
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      maxwidth = 60,
      ellipsis_char = "...", -- when pop-up menu exceeds maxwidth
      preset = "codicons",
    }),
    -- format = function(entry, vim_item)
    --   -- Fancy icons and a name of kind
    --   vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
    --   return vim_item
    -- end,
  },
})


-- setup completion for command line search with / and ?
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})


-- setup completion for command line commands
cmp.setup.cmdline({ ":" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" }
  }
  ),
})

-- Lazyload installed snippets
require("luasnip.loaders.from_vscode").lazy_load()
--{
-- paths = {
--   -- vim.fn.globpath(vim.fn.stdpath("data"), "**/snippets")
--   vim.fn.stdpath("data") .. "/lazy/friendly-snippets/snippets",
--   vim.fn.stdpath("data") .. "/lazy/vim-snippets/snippets",
-- }
-- }

-- From nvim-cmp wiki Example-mappings#supertab-like-mappings#luasnip
local function has_words_before()
  table.unpack = table.unpack or unpack -- avoid deprecation warning for lua>5.1
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  -- preselect = cmp.PreselectMode.Item,
  enabled = function()
    local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
    if in_prompt then
      return false
    end
    local context = require "cmp.config.context"
    return not (context.in_treesitter_capture "comment" == true or context.in_syntax_group "Comment")
  end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    -- Order dictates priority of completion suggestions
    { name = "nvim_lua" }, -- source only enables itself inside of lua buffers
    { name = "path" },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "buffer",   keyword_length = 5 },
    { name = "luasnip",  keyword_length = 2 },
  }),
  window = {
    -- NOTE: Author will merge this to `view` in the future
    documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...", -- when pop-up menu exceeds maxwidth
      preset = "codicons",
    }),
    mapping = {
      ["<CR>"] = cmp.mapping.confirm({
        cmp.SelectBehavior.Replace,
        select = false,
      }),
      ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
      ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      -- NOTE: New from nvim-cmp https://github.com/hrsh7th/nvim-cmp/issues/231
      -- ["<C-x><C-s>"] = cmp.mapping.complete({
      --   config = { sources = { name = "luasnip" } }
      -- }),

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
      -- Autocomplete with TABS
      -- If completion menu is visible, move to next item. If line is empty insert
      -- a TAB character. If cursor is inside a word, trigger the completion menu.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
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
    },
    -- NOTE: New from nvim-cmp https://github.com/hrsh7th/nvim-cmp/issues/231
    -- Instead of expreimental.native_menu = true, following is added
    view = { entries = "new" },
    experimental = { ghost_text = true },

    -- for clangd_extensions
    sorting = { comparators = { require("clangd_extensions.cmp_scores") } },
  }
})

-- Load snippets from "friendly-snippets" using LuaSnip snippets engine
require("luasnip.loaders.from_vscode").lazy_load()

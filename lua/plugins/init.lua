--==============================================================================
--                          Plugin Manager
--==============================================================================

-- Plugin-manager: lazy.nvim
-- Auto-install plugin-manager if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim....")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    --=========================================================================
    -- COLORSCHEMES
    --=========================================================================
    -- Theme Based on Google's Material Design (default)
    { "NLKNguyen/papercolor-theme" },

    -- IBM Carbon inspired theme
    { "nyoom-engineering/oxocarbon.nvim" },

    -- Inspired by colors of the famous painting by Katsushika Hokusai
    { "rebelot/kanagawa.nvim" },

    -- A dark charcoal theme
    { "bluz71/vim-moonfly-colors" },

    -- A soothing pastel theme (light: latte | dark: mocha, macchiato, frappe)
    { "catppuccin/nvim",                 name = "catppuccin" },

    -- low-contrast dark theme
    { "dasupradyumna/midnight.nvim" },

    --=========================================================================
    -- Manage LSP related plugins
    --=========================================================================

    -- LSP support
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- clangd's off-spec features for neovim LSP client
    { "p00f/clangd_extensions.nvim" },

    -- Formatter (formatter function of null-ls!)
    -- autocmd setup in after/plugins/autocmd.lua
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          python = { "isort", "black" },
        },
      }
    },


    --=========================================================================
    -- AUTO-COMPLETION
    --=========================================================================
    -- official completion engine
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "onsails/lspkind.nvim", -- cool symbols
        "hrsh7th/cmp-nvim-lsp", -- completion sources: LSP
        "hrsh7th/cmp-buffer",   -- completion sources: words in open buffers
        "hrsh7th/cmp-cmdline",  -- completion sources: commands
        "hrsh7th/cmp-path",     -- completion sources: file paths
      },
      lazy = true,
    },

    -- snippet engines
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = "make install_jsregexp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",                          -- luasnip does not work with nvim-cmp without this!
        "rafamadriz/friendly-snippets", "honza/vim-snippets" -- snippet frameworks
      },
      lazy = true,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
      build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
      end,
      config = function(plugin)
        require("plugins.treesitter")
        vim.notify("Loaded " .. plugin.name, vim.log.levels.INFO,
          { title = "Plugin Configuration" }
        )
      end,
    },

    -- Comment/uncomment code with gcc, gc{motion}
    { "numToStr/Comment.nvim",  opts = {} },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
    { "jiangmiao/auto-pairs" },

    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = "nvim-lua/plenary.nvim",
      lazy = true,
    },

    -- status line
    {
      "nvim-lualine/lualine.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
    },

    -- Git integration for buffers
    {
      "lewis6991/gitsigns.nvim",
      dependencies = "nvim-lua/plenary.nvim",
    },

    -- Floating terminal
    { "akinsho/toggleterm.nvim",             opts = {} },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    -- Vimwiki for notetaking
    {
      "vimwiki/vimwiki",
      -- NOTE: vimwiki needs to know `g:vimwiki_list` before loading vimwiki
      -- plugin. `config` loads only AFTER plugin loads, `init` loads BEFORE
      -- plugin loads
      init = function()
        vim.g.vimwiki_list = {
          {
            template_path = vim.fn.stdpath("data") .. "/lazy/vimwiki/autoload/vimwiki",
            path = "/home/akalanka/Documents/notes",
            syntax = "markdown",
            ext = ".md",
          }
        }
        vim.g.vimwiki_global_ext = 0
      end,
      event = "VeryLazy",
    },

  },


  -- Options for lazy.nvim
  {
    defaults = { lazy = false }, -- plugins do not lazy-load by default
    lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
  })

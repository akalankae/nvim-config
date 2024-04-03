#!/usr/bin/env lua

-- File name: lua/plugins/lsp/clangd.lua
-- Author: Akalanka Edirisinghe <akalankae@gmail.com>
-- Created on: 22 Feb 24
-- Last Modified: 22 Feb 24 10.39 PM
-- Description: configuration for clangd_extensions.nvim

require("clangd_extensions.inlay_hints").setup_autocmd()
require("clangd_extensions.inlay_hints").set_inlay_hints()

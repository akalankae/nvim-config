local settings = {
        expandtab = true, -- space replaces tab
        softtabstop = 4, -- number of spaces tab/backspace make cursor move
        shiftwidth = 4,  -- number of spaces used for indentation

        number = true,
        relativenumber = true,
        textwidth = 80, -- max line length
        signcolumn = "auto", -- hide signcolumn if nothing to show
        colorcolumn = "+0", -- highlight last column

        ignorecase = true,
        smartcase = true,
        undofile = true,
        undodir = os.getenv("HOME") .. "/.vim/undodir",

        mouse = "a",
        cursorline = true,  -- highlight line cursor is on
        splitright = true,  -- split new windows to right of opened window
        splitbelow = true,  -- split new windows below opened window
        dictionary = "/usr/share/dict/allwords.txt",

        termguicolors = vim.fn.has("termguicolors") and true or false,

}

for option, value in pairs(settings) do
        vim.opt[option] = value
end

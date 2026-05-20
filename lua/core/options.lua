vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 0
vim.opt.guicursor = "a:block"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.scrolloff = 2
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 200
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c")
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.netrw_dir_marker = 1
vim.g.netrw_special_syntax = 3
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 0

vim.opt.winborder = "rounded"
vim.opt.fillchars = { eob = " ", fold = " ", vert = "│" }
vim.opt.list = true
vim.opt.listchars = {
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
vim.lsp.log.set_level("error")
vim.lsp.inlay_hint.enable(true)
vim.lsp.handlers["$/progress"] = function() end

-- vim.opt.spell = true
-- vim.opt.spelllang = { "en_us", "pt_br" }
vim.opt.linebreak = true
vim.opt.confirm = false
vim.opt.signcolumn = "no"
vim.opt.colorcolumn = "0"


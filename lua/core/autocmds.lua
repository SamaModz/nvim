local augroup = vim.api.nvim_create_augroup('UserAutocmds', { clear = true }) -- Clear o augroup para evitar duplicações ao recarregar

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  pattern = { '*.lua', '*.js', '*.sh' },
  callback = function()
    if vim.lsp.get_clients({ bufnr = 0 }) then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup,
  pattern = '*',
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

local function set_cursorline(bg, fg)
  vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = fg, bold = true })
end

local colors = {
  normal  = { bg = "#444444", fg = "#a0a0a0" },
  insert  = { bg = "#1f3b2c", fg = "#6fcf97" },
  visual  = { bg = "#3b2a1f", fg = "#f2c94c" },
  command = { bg = "#2a1f3b", fg = "#bb86fc" },
}

vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "*:n",
  callback = function()
    set_cursorline(colors.normal.bg, colors.normal.fg)
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "*:i",
  callback = function()
    set_cursorline(colors.insert.bg, colors.insert.fg)
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "*:[vV ]",
  callback = function()
    set_cursorline(colors.visual.bg, colors.visual.fg)
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "*:c",
  callback = function()
    set_cursorline(colors.command.bg, colors.command.fg)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    set_cursorline(colors.normal.bg, colors.normal.fg)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    if vim.fn.mode() == 'n' then
      set_cursorline(colors.normal.bg, colors.normal.fg)
    end
  end,
})

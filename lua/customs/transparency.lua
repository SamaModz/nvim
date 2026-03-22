local M = {}

local default_groups = {
  "Normal",
  "SignColumn",
  "MsgArea",
  "ModeMsg",
  "MsgSeparator",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "VertSplit",
  "WinSeparator",
  "LineNr",
  "CursorLineNr",
  "Folded",
  "FoldColumn",
  "EndOfBuffer",
  "QuickFixLine",
  "Search",
  "IncSearch",
  "StatusLine",
  "StatusLineNC",
  "Pmenu",
  "PmenuSel",
  "PmenuSbar",
  "PmenuThumb",
  "NotifyBackground",
}

function M.set_transparent(groups)
  groups = groups or default_groups

  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
    if ok and hl then
      hl.bg = "NONE"      -- @string
      hl.ctermbg = "NONE" -- @string
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

M.set_transparent()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    M.set_transparent()
  end,
})

return M

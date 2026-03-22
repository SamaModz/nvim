local UI = {}

UI.config = {
  adaptive_colors = true,
  transparent     = true,
  git             = true,
  lsp             = true,
  diagnostics     = true,
}

local function hex(n)
  return n and string.format("#%06x", n) or nil
end

local function get_hl(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok and hl and hl.fg then
    return hex(hl.fg)
  end
  return fallback
end

local function get_bg(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok and hl and hl.bg then
    return hex(hl.bg)
  end
  return fallback
end


local function get_mode_accent()
  local m = vim.fn.mode()

  local map = {
    n = "Keyword",
    i = "String",
    v = "Type",
    V = "Type",
    ["\22"] = "Type",
    c = "Function",
    R = "Error",
    t = "Special",
  }

  local group = map[m] or "Keyword"
  return get_hl(group, "#89b4fa")
end

local function mode_label()
  local m = vim.fn.mode()
  local labels = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    R = "REPLACE",
    t = "TERMINAL",
  }

  return labels[m] or m:upper()
end

function UI.set_highlights()
  local fixed_fg = get_hl("Normal", "#1a1a1e")

  local bg = UI.config.transparent and "NONE"
      or get_bg("Normal", "NONE")

  local accent = get_mode_accent()

  vim.api.nvim_set_hl(0, "StatusLine", {
    fg = fixed_fg,
    bg = bg,
  })

  vim.api.nvim_set_hl(0, "StatusLineNC", {
    fg = fixed_fg,
    bg = bg,
  })

  vim.api.nvim_set_hl(0, "UIMode", {
    fg = "#1a1a1e",
    bg = accent,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "UISeparator", {
    fg = fixed_fg,
    bg = bg,
  })
end

local function mode()
  return table.concat({
    "%#UIMode# ",
    mode_label(),
    " %#UISeparator# %#StatusLine#"
  })
end

local git_cache = { branch = "", time = 0 }

local function git_branch()
  if not UI.config.git then return "" end

  local now = vim.loop.hrtime()
  if now - git_cache.time < 2e9 then
    if git_cache.branch ~= "" then
      return " " .. git_cache.branch .. " "
    end
    return ""
  end

  git_cache.time = now

  local handle = io.popen("git branch --show-current 2>/dev/null")
  if not handle then return "" end

  local branch = handle:read("*a"):gsub("%s+", "")
  handle:close()

  git_cache.branch = branch
  if branch == "" then return "" end

  return " " .. branch .. " "
end

local function lsp()
  if not UI.config.lsp then return "" end

  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end

  return " " .. clients[1].name .. " "
end

local function diagnostics()
  if not UI.config.diagnostics then return "" end

  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local parts = {}
  if e > 0 then table.insert(parts, " " .. e) end
  if w > 0 then table.insert(parts, " " .. w) end

  if #parts == 0 then return "" end
  return table.concat(parts, " ") .. " "
end

function UI.statusline()
  return table.concat({
    mode(),
    "%t %m ",
    "%=",
    diagnostics(),
    git_branch(),
    lsp(),
  })
end

function UI.setup(opts)
  UI.config = vim.tbl_extend("force", UI.config, opts or {})

  UI.set_highlights()

  if UI.config.adaptive_colors then
    vim.api.nvim_create_autocmd({ "ColorScheme", "ModeChanged" }, {
      callback = function()
        UI.set_highlights()
        vim.cmd("redrawstatus")
      end,
    })
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      UI.set_highlights()
      vim.cmd("redrawstatus")
    end,
  })

  _G.OneUI = UI
  vim.o.statusline = "%!v:lua.OneUI.statusline()"
end

return UI.setup({
  adaptive_colors = false,
  transparent     = false,
  git             = true,
  lsp             = true,
  diagnostics     = true,
})

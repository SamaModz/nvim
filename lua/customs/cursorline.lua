local M = {}


local function hex(n)
  return n and string.format("#%06x", n) or nil
end

local function get_fg(name, fallback)
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
  return get_fg(group, "#89b4fa")
end


local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return {
    r = tonumber(hex:sub(1, 2), 16),
    g = tonumber(hex:sub(3, 4), 16),
    b = tonumber(hex:sub(5, 6), 16),
  }
end

local function rgb_to_hex(rgb)
  return string.format("#%02x%02x%02x", rgb.r, rgb.g, rgb.b)
end

local function blend(fg, bg, alpha)
  local fg_rgb = hex_to_rgb(fg)
  local bg_rgb = hex_to_rgb(bg)

  return rgb_to_hex({
    r = math.floor((alpha * fg_rgb.r) + ((1 - alpha) * bg_rgb.r)),
    g = math.floor((alpha * fg_rgb.g) + ((1 - alpha) * bg_rgb.g)),
    b = math.floor((alpha * fg_rgb.b) + ((1 - alpha) * bg_rgb.b)),
  })
end


local function set_cursorline()
  local accent = get_mode_accent()
  local normal_bg = get_bg("Normal", "#1e1e2e")

  if not accent then return end

  if not normal_bg then
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", {
      fg = accent,
      bold = true,
    })
    return
  end

  local blended = blend(accent, normal_bg, 0.25)

  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = blended,
  })

  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = accent,
    bold = true,
  })
end


function M.setup()
  local group = vim.api.nvim_create_augroup("DynamicCursorLine", { clear = true })

  vim.api.nvim_create_autocmd({ "ModeChanged", "ColorScheme", "VimEnter" }, {
    group = group,
    callback = function()
      set_cursorline()
    end,
  })

  set_cursorline()
end

return M.setup()

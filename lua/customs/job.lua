local M             = {}

local ns            = vim.api.nvim_create_namespace("job_time_ns")

local DEFAULT_START = 22 * 60 + 40
local DEFAULT_END   = 6 * 60

if DEFAULT_END < DEFAULT_START then
  DEFAULT_END = DEFAULT_END + (24 * 60)
end

local DEFAULT_TOTAL = DEFAULT_END - DEFAULT_START

local function is_job_file(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name:match("%.job$")
end

local function time_to_minutes(time)
  local h, m = time:match("(%d%d):(%d%d)")
  if not h then return nil end
  return tonumber(h) * 60 + tonumber(m)
end

local function parse_line(line)
  local start_t, end_t = line:match("(%d%d:%d%d)%s*/%s*(%d%d:%d%d)")
  if not start_t or not end_t then return nil end

  local start_min = time_to_minutes(start_t)
  local end_min   = time_to_minutes(end_t)
  if not start_min or not end_min then return nil end

  if end_min < start_min then
    end_min = end_min + (24 * 60)
  end

  return start_min, end_min
end

local function format_diff(diff)
  if diff == 0 then
    return "0min"
  end

  local sign = diff > 0 and "+" or "-"
  local abs  = math.abs(diff)

  if abs < 60 then
    return sign .. abs .. "min"
  end

  local hours   = math.floor(abs / 60)
  local minutes = abs % 60

  if minutes == 0 then
    return sign .. hours .. "h"
  end

  return sign .. hours .. "h" .. minutes
end

local function highlight_for(diff)
  if diff < 0 then
    return "DiagnosticError"
  elseif diff > 0 then
    return "DiagnosticOk"
  else
    return "DiagnosticHint"
  end
end

local function update(bufnr)
  if not is_job_file(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    vim.diagnostic.reset(ns, bufnr)
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local total_diff = 0

  for i, line in ipairs(lines) do
    local start_min, end_min = parse_line(line)

    if start_min and end_min then
      local worked = end_min - start_min
      local diff   = worked - DEFAULT_TOTAL

      total_diff   = total_diff + diff

      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, -1, {
        virt_text = {
          { " => " .. format_diff(diff), highlight_for(diff) },
        },
        virt_text_pos = "eol",
      })
    end
  end

  if total_diff ~= 0 then
    vim.diagnostic.set(ns, bufnr, {
      {
        lnum = 0,
        col = 0,
        severity = total_diff < 0
            and vim.diagnostic.severity.ERROR
            or vim.diagnostic.severity.HINT,
        message = "󱐋 Saldo do dia: " .. format_diff(total_diff),
      },
    }, { virtual_text = true })
  else
    vim.diagnostic.reset(ns, bufnr)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "TextChanged",
    "TextChangedI",
    "InsertLeave",
  }, {
    callback = function(args)
      update(args.buf)
    end,
  })
end

return M.setup()

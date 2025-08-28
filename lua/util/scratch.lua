local M = {}

local defaults = {
  name = "Output",
  ft = vim.bo.filetype,
  ---@type string|string[]?
  icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
  win = { style = "output" },
}

local output_height = 20
Snacks.config.style("output", {
  width = 0,
  height = output_height,
  backdrop = false,
  row = vim.api.nvim_get_option_value("lines", {}) - output_height,
  border = "top",
  bo = {
    buftype = "nofile",
    buflisted = false,
    bufhidden = "wipe",
    swapfile = false,
    undofile = false,
    modifiable = false, -- 不可修改
  },
  minimal = false,
  noautocmd = false,
  zindex = 100,
  ft = "output",
  wo = {
    -- 默认highlight: "NormalFloat:Normal,FloatBorder:WinSeparator",
    winhighlight = "NormalFloat:NormalFloat,FloatBorder:WhichKeyBorder,CursorLine:NeoTreeCursorLine",
    colorcolumn = "",
    number = false,
    relativenumber = false,
  },
})

--- Show lines in a floating buffer at the bottom.
---@param lines string
---@param fopts? snacks.scratch.Config
local function show_output(lines, fopts)
  fopts = Snacks.config.get("output", defaults, fopts)
  fopts.win = Snacks.win.resolve("output", fopts.win, { show = false })

  local out_buf = vim.api.nvim_create_buf(false, true)

  local content = {}
  for line in lines:gmatch("([^\n]*)\n?") do
    table.insert(content, line)
  end
  -- Remove trailing empty lines
  for i = #content, 1, -1 do
    if content[i] == "" then
      table.remove(content, i)
    else
      break
    end
  end
  vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, content)
  fopts.win.buf = out_buf
  return Snacks.win(fopts.win):show()
end

--- Run the current buffer or a range of lines.
--- Shows the output in a scratch buffer at the bottom.
---@param fopts? {name?:string, buf?:number, print?:boolean}
M.runPython = function(fopts)
  local ns = vim.api.nvim_create_namespace("snacks_debug")
  fopts = vim.tbl_extend("force", { print = true }, fopts or {})
  local buf = fopts.buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  local name = fopts.name or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")

  -- Get the lines to run
  local lines ---@type string[]
  local mode = vim.fn.mode()
  if mode:find("[vV]") then
    if mode == "v" then
      vim.cmd("normal! v")
    elseif mode == "V" then
      vim.cmd("normal! V")
    end
    local from = vim.api.nvim_buf_get_mark(buf, "<")
    local to = vim.api.nvim_buf_get_mark(buf, ">")

    -- for some reason, sometimes the column is off by one
    -- see: https://github.com/folke/snacks.nvim/issues/190
    local col_to = math.min(to[2] + 1, #vim.api.nvim_buf_get_lines(buf, to[1] - 1, to[1], false)[1])

    lines = vim.api.nvim_buf_get_text(buf, from[1] - 1, from[2], to[1] - 1, col_to, {})
    -- Insert empty lines to keep the line numbers
    for _ = 1, from[1] - 1 do
      table.insert(lines, 1, "")
    end
    vim.fn.feedkeys("gv", "nx")
  else
    lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  end

  -- Clear diagnostics and extmarks
  local function reset()
    vim.diagnostic.reset(ns, buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  end
  reset()
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = vim.api.nvim_create_augroup("snacks_debug_run_" .. buf, { clear = true }),
    buffer = buf,
    callback = reset,
  })

  local command = "echo " .. vim.fn.shellescape(table.concat(lines, "\n")) .. " | python3 2>&1"
  -- 对字符串里的换行符转义
  command = command:gsub("\\n", "\\\\n")
  local handle = io.popen(command)
  if not handle then
    Snacks.notify.error("Didn't get popen handle.", { title = name })
    return
  end
  local out = handle:read("*a")
  handle:close()

  if out == "" then
    Snacks.notify.info("No output.", { title = name, ft = "python" })
  else
    show_output(out)
  end
end

return M

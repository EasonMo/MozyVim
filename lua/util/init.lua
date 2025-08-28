local M = {}
M.general_root = { ".project.*", ".git/", "README.md" }

-- 全局函数
function Close_all()
  if vim.fn.exists(":Neotree") == 2 then
    vim.cmd("Neotree close")
  end

  if vim.fn.exists(":OutlineClose") == 2 then
    vim.cmd("OutlineClose")
  end
  -- vim.api.nvim_command("Neotree close")
  -- vim.api.nvim_command("OutlineClose")
end

-- 定义一个函数，用于执行按键序列
--   示例：执行一个按键序列，比如 "ggdG", execute_key_sequence("ggdG")
function M.execute_key_sequence(keys)
  -- 将按键序列传递给 nvim_feedkeys 函数
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

function M.close_other_windows()
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_list_wins()

  for _, win in ipairs(wins) do
    if win ~= current_win then
      vim.api.nvim_win_close(win, true)
    end
  end
end

function M.log(obj)
  print(vim.inspect(obj))
end

function M.find_buffer_by_name(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end
  return -1
end

function M.find_buffers_by_filetype(filetype)
  local buffers = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == filetype then
        table.insert(buffers, bufnr)
      end
    end
  end
  return buffers
end

function M.file_exists(filepath)
  return vim.fn.glob(filepath) ~= ""
end

function M.get_parent_dir(path)
  return path:match("(.+)/")
end

function M.copy_file(source_file, target_file)
  local target_file_parent_path = M.get_parent_dir(target_file)
  local cmd = string.format("mkdir -p %s", vim.fn.shellescape(target_file_parent_path))
  os.execute(cmd)
  cmd = string.format("cp %s %s", vim.fn.shellescape(source_file), vim.fn.shellescape(target_file))
  os.execute(cmd)
  vim.schedule(function()
    vim.notify("File " .. target_file .. " created success.", vim.log.levels.INFO)
  end)
end

function M.get_launch_json_by_source_file(source_file)
  local target_file = vim.fn.getcwd() .. "/.vscode/launch.json"
  local file_exist = M.file_exists(target_file)
  if file_exist then
    local confirm = vim.fn.confirm("File `.vscode/launch.json` Exist, Overwrite it?", "&Yes\n&No", 1, "Question")
    if confirm == 1 then
      M.copy_file(source_file, target_file)
    end
  else
    M.copy_file(source_file, target_file)
  end
end

function M.get_tasks_json_by_source_file(source_file)
  local target_file = vim.fn.getcwd() .. "/.vscode/tasks.json"
  local file_exist = M.file_exists(target_file)
  if file_exist then
    local confirm = vim.fn.confirm("File `.vscode/tasks.json` Exist, Overwrite it?", "&Yes\n&No", 1, "Question")
    if confirm == 1 then
      M.copy_file(source_file, target_file)
    end
  else
    M.copy_file(source_file, target_file)
  end
end

function M.create_launch_json()
  vim.ui.select({
    "go",
    "node",
    "rust",
    "python",
  }, { prompt = "Select Language Debug Template", default = "go" }, function(select)
    if not select then
      return
    end
    if select == "go" then
      local source_file = vim.fn.stdpath("config") .. "/templates/vscode/go_launch.json"
      M.get_launch_json_by_source_file(source_file)
    elseif select == "node" then
      local source_file = vim.fn.stdpath("config") .. "/templates/vscode/node_launch.json"
      M.get_launch_json_by_source_file(source_file)
    elseif select == "rust" then
      local source_file = vim.fn.stdpath("config") .. "/templates/vscode/rust_launch.json"
      M.get_launch_json_by_source_file(source_file)
      source_file = vim.fn.stdpath("config") .. "/templates/vscode/rust_tasks.json"
      M.get_tasks_json_by_source_file(source_file)
    elseif select == "python" then
      local source_file = vim.fn.stdpath("config") .. "/templates/vscode/python_launch.json"
      M.get_launch_json_by_source_file(source_file)
    end
  end)
end

function M.file_name_copy_selector(filename, filepath)
  local modify = vim.fn.fnamemodify

  local vals = {
    ["1.FILENAME"] = filename,
    ["2.BASENAME"] = modify(filename, ":r"),
    ["3.EXTENSION"] = modify(filename, ":e"),
    ["4.PATH (CWD)"] = modify(filepath, ":."),
    ["5.PATH (HOME)"] = modify(filepath, ":~"),
    ["6.PATH (ABS)"] = filepath,
    ["7.URI"] = vim.uri_from_fname(filepath),
  }

  local options = vim.tbl_filter(function(val)
    return vals[val] ~= ""
  end, vim.tbl_keys(vals))
  if vim.tbl_isempty(options) then
    vim.notify("No values to copy", vim.log.levels.WARN)
    return
  end
  table.sort(options)
  vim.ui.select(options, {
    prompt = "Choose to copy to clipboard:",
    format_item = function(item)
      return ("%s: %s"):format(string.sub(item, 3), vals[item])
    end,
  }, function(choice)
    local result = vals[choice]
    if result then
      vim.notify(("Copied: `%s`"):format(result))
      vim.fn.setreg("+", result)
      vim.fn.setreg("0", result)
    end
  end)
end

return M

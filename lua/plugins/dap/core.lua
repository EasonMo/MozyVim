---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      -- 启动调试前，关闭其他窗口
      { "<leader>da", function() Close_all();require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dc", function() Close_all();require("dap").continue() end, desc = "Continue" },
      { "<F5>", function() Close_all(); require("dap").continue() end, desc = "DAP: Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<F23>", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoint"},
    },
  },
}

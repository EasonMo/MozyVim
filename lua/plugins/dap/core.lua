local utils = require("utils")

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

local layout_3_list = { "javascript", "typescript", "typescriptreact", "javascriptreact" }
local function get_layout()
  for _, element in ipairs(layout_3_list) do
    if vim.bo.filetype == element then
      return 3
    end
  end
  return 2
end

return {
  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      -- 启动调试前，关闭其他窗口
      { "<leader>da", function() Close_all();require("dap").continue({ before = get_args }) end,          desc = "Run with Args" },
      { "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end,           desc = "Toggle Breakpoint (F9)" },
      { "<F9>",       function() require("persistent-breakpoints.api").toggle_breakpoint() end,           desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,  desc = "Breakpoint Condition" },
      { "<leader>dc", function() Close_all();require("dap").continue() end,                               desc = "Run/Continue (F5)" },
      { "<F5>",       function() Close_all(); require("dap").continue() end,                              desc = "Run/Continue" },
      { "<leader>dL", function() require("persistent-breakpoints.api").set_log_point() end,               desc = "Breakpoint Log" },
      { "<leader>di", function() require("dap").step_into() end,                                          desc = "Step Into (F11)" },
      { "<F11>",      function() require("dap").step_into() end,                                          desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end,                                          desc = "Step Over (F10)" },
      { "<F10>",      function() require("dap").step_over() end,                                          desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end,                                           desc = "Step Out (S+F11)" },
      { "<S-F11>",    function() require("dap").step_out() end,                                           desc = "Step Out" },
      { "<F23>",      function() require("dap").step_out() end,                                           desc = "Step Out" },  -- 即shift+F11
      { "<leader>dx", function() require("persistent-breakpoints.api").clear_all_breakpoints() end,       desc = "Clear Breakpoint"},
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ layout = get_layout(), reset = true }) end,  desc = "Dap UI" },
      { "<leader>dU", function() require("dapui").toggle({ layout = 1, reset = true }) end,             desc = "Dap UI (left)" },
    },
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
        {
          elements = { { id = "repl", size = 10 } },
          position = "bottom",
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      local function clear_dap_ui()
        local bufs = utils.find_buffers_by_filetype("dap-repl")
        for _, buf in ipairs(bufs) do
          vim.bo[buf].buflisted = false
        end
        dapui.close({})
      end
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ layout = get_layout(), reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        clear_dap_ui()
      end
      dap.listeners.after.disconnect["dapui_config"] = function()
        clear_dap_ui()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  -- dap补全
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      -- add source
      { "rcarriga/cmp-dap" },
    },
    sources = {
      completion = {
        -- remember to enable your providers here
        enabled_providers = { "dap" },
      },
      providers = {
        -- create provider
        dap = {
          name = "dap",
          module = "blink.compat.source",
          -- all blink.cmp source config options work as normal:
          score_offset = -3,
        },
      },
    },
  },
  -- dap高亮
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dap_repl" } },
  },
  {
    "LiadOz/nvim-dap-repl-highlights",
    event = "VeryLazy",
    config = function()
      require("nvim-dap-repl-highlights").setup()
    end,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "VeryLazy",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
  },
}

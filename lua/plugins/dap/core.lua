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
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP: Step Over" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step Into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<F23>", function() require("dap").step_out() end, desc = "DAP: Step Out" },  -- 即shift+F11
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoint"},
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ layout = 2, reset = true }) end, desc = "Dap UI" },
      { "<leader>dU", function() require("dapui").toggle({ layout = 1, reset = true }) end, desc = "Dap UI (all)" },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ layout = 2, reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  -- dap补全
  {
    "rcarriga/cmp-dap",
    event = "VeryLazy",
    config = function()
      require("cmp").setup({
        enabled = function()
          ---@diagnostic disable-next-line: deprecated
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
      })

      require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
      local dap = require("dap")
      -- 修正dap-repl buffer不关闭
      dap.listeners.before["event_terminated"]["hide-dap-repl"] = function()
        local bufs = utils.find_buffers_by_filetype("dap-repl")
        for _, buf in ipairs(bufs) do
          vim.bo[buf].buflisted = false
        end
      end
    end,
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
}

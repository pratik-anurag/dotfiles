return {
  { "mfussenegger/nvim-dap", keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" }, { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" }, { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" }, { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" }, { "<leader>dc", function() require("dap").continue() end, desc = "Debug continue" }, { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug REPL" }, { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
    } },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, config = function()
      local dap, dapui = require("dap"), require("dapui"); dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end },
  { "theHamsta/nvim-dap-virtual-text", opts = {} }, { "leoluz/nvim-dap-go", dependencies = { "mfussenegger/nvim-dap" }, opts = {} },
  { "mfussenegger/nvim-dap-python", dependencies = { "mfussenegger/nvim-dap" }, config = function() require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python") end },
  { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" }, config = function()
      require("dap-vscode-js").setup({ debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter", adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" } })
      local dap = require("dap")
      for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do dap.configurations[language] = { { type = "pwa-node", request = "launch", name = "Launch current file", program = "${file}", cwd = "${workspaceFolder}", runtimeExecutable = "node" } } end
    end },
  { "nvim-neotest/neotest", dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "mfussenegger/nvim-dap", "nvim-neotest/neotest-go", "nvim-neotest/neotest-python", "marilari88/neotest-vitest" }, config = function() require("neotest").setup({ adapters = { require("neotest-go"), require("neotest-python")({ dap = { justMyCode = false } }), require("neotest-vitest") } }) end, keys = { { "<leader>Tn", function() require("neotest").run.run() end, desc = "Test nearest" }, { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" }, { "<leader>Ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test all" }, { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" }, { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test summary" }, { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" } } },
}

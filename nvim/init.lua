-- Personal Neovim setup: batteries included, with conservative defaults.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.termguicolors = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.cursorline = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/tokyonight.nvim", priority = 1000, config = function() vim.cmd.colorscheme("tokyonight-night") end },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = { options = { theme = "tokyonight" } } },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local function button(shortcut, label, command)
        local item = dashboard.button(shortcut, string.format("[%s] %s", shortcut, label), command)
        item.opts.hl = "Keyword"
        item.opts.hl_shortcut = "Number"
        return item
      end
      local function git_status()
        local branch = vim.fn.systemlist({ "git", "branch", "--show-current" })[1]
        if vim.v.shell_error ~= 0 or not branch or branch == "" then return "Git: not a repository" end
        local changes = vim.fn.system({ "git", "status", "--porcelain" })
        return changes == "" and ("Git: " .. branch .. " (clean)") or ("Git: " .. branch .. " (changes)")
      end
      dashboard.section.header.val = {
        "",
        "  66666   7777777 ",
        " 66          77   ",
        " 66666      77    ",
        " 66  66    77     ",
        "  66666   77      ",
        "",
      }
      dashboard.section.buttons.val = {
        button("f", "Find file", "<cmd>Telescope find_files<CR>"),
        button("r", "Recent files", "<cmd>Telescope oldfiles<CR>"),
        button("p", "Recent projects", "<cmd>Telescope repo list<CR>"),
        button("n", "New file", "<cmd>ene<CR>"),
        button("s", "Restore session", function() require("persistence").load() end),
        button("q", "Quit", "<cmd>qa<CR>"),
      }
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        return {
          "",
          "\"Maybe that's what Batman is about. Not winning. But failing, and getting back up.",
          "Knowing he'll fail, fail a thousand times, but still won't give up.\"",
          "— Batman",
          "",
          git_status(),
          string.format("Loaded %d plugins in %.2f ms", stats.count, stats.startuptime),
        }
      end
      dashboard.section.footer.opts.hl = "Comment"
      dashboard.section.header.opts.hl = "Title"
      dashboard.section.buttons.opts.hl = "Keyword"
      alpha.setup(dashboard.config)
    end,
  },
  { "akinsho/toggleterm.nvim", version = "*", opts = {
      size = 15,
      open_mapping = [[<c-\\>]],
      direction = "horizontal",
      shade_terminals = true,
    },
    keys = { { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" } },
  },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
      view = { width = 32, side = "left" },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      update_focused_file = { enable = true },
    },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" } },
  },
  { "NeogitOrg/neogit", dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
    opts = { integrations = { diffview = true, telescope = true } },
    keys = { { "<leader>gg", "<cmd>Neogit<CR>", desc = "Git status" } },
  },
  { "sindrets/diffview.nvim", keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Git diff" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Git diff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    },
  },
  { "folke/trouble.nvim", opts = {}, keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
    },
  },
  { "folke/persistence.nvim", event = "BufReadPre", opts = {}, keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop session saving" },
    },
  },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {}, keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
    },
  },
  { "folke/flash.nvim", event = "VeryLazy", opts = {}, keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },
  { "echasnovski/mini.ai", version = false, opts = { n_lines = 500 } },
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
  { "stevearc/aerial.nvim", opts = {}, keys = {
      { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle symbol outline" },
    },
  },
  { "MagicDuck/grug-far.nvim", opts = {}, keys = {
      { "<leader>sr", function() require("grug-far").open() end, desc = "Search and replace" },
      { "<leader>sw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Replace word" },
    },
  },
  { "stevearc/overseer.nvim", opts = {}, keys = {
      { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<CR>", desc = "Task list" },
    },
  },
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" }, opts = {}, dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" } },
  { "linux-cultist/venv-selector.nvim", dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" }, opts = {}, keys = {
      { "<leader>pv", "<cmd>VenvSelect<CR>", desc = "Select Python environment" },
    },
  },
  { "mfussenegger/nvim-dap", keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug continue" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
    },
  },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
  { "theHamsta/nvim-dap-virtual-text", opts = {} },
  { "leoluz/nvim-dap-go", dependencies = { "mfussenegger/nvim-dap" }, opts = {} },
  { "mfussenegger/nvim-dap-python", dependencies = { "mfussenegger/nvim-dap" }, config = function()
      require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    end,
  },
  { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" }, config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
      local dap = require("dap")
      for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[language] = {
          { type = "pwa-node", request = "launch", name = "Launch current file", program = "${file}", cwd = "${workspaceFolder}", runtimeExecutable = "node" },
        }
      end
    end,
  },
  { "nvim-neotest/neotest", dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "mfussenegger/nvim-dap", "nvim-neotest/neotest-go", "nvim-neotest/neotest-python", "marilari88/neotest-vitest" }, config = function()
      require("neotest").setup({ adapters = {
        require("neotest-go"),
        require("neotest-python")({ dap = { justMyCode = false } }),
        require("neotest-vitest"),
      } })
    end,
    keys = {
      { "<leader>Tn", function() require("neotest").run.run() end, desc = "Test nearest" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
      { "<leader>Ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test all" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
    },
  },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search text" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    },
  },
  { "cljoly/telescope-repo.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, config = function()
      require("telescope").load_extension("repo")
    end,
    keys = { { "<leader>fp", "<cmd>Telescope repo list<CR>", desc = "Find projects" } },
  },
  { "mfussenegger/nvim-lint", event = { "BufReadPost", "BufNewFile" }, config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" }, python = { "ruff" }, javascript = { "eslint_d" },
        typescript = { "eslint_d" }, javascriptreact = { "eslint_d" }, typescriptreact = { "eslint_d" }, yaml = { "yamllint" },
      }
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, { callback = function() lint.try_lint() end })
      vim.api.nvim_create_autocmd("BufWritePost", { pattern = { ".github/workflows/*.yml", ".github/workflows/*.yaml" }, callback = function() lint.try_lint("actionlint") end })
    end,
  },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opts = {
      ensure_installed = { "bash", "css", "go", "gomod", "gosum", "gowork", "html", "javascript", "json", "lua", "markdown", "python", "tsx", "typescript", "vim", "yaml" },
      highlight = { enable = true }, indent = { enable = true },
    },
  },
  { "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 4, mode = "cursor" } },
  { "williamboman/mason.nvim", opts = {} },
  { "WhoIsSethDaniel/mason-tool-installer.nvim", dependencies = { "williamboman/mason.nvim" }, opts = { ensure_installed = { "eslint_d", "js-debug-adapter", "golangci-lint", "yamllint", "actionlint" } } },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" }, opts = {
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "bashls", "gopls", "jsonls", "yamlls" },
    },
  },
  { "neovim/nvim-lspconfig", dependencies = { "b0o/SchemaStore.nvim" }, config = function()
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
      vim.diagnostic.config({ virtual_text = true, severity_sort = true, float = { border = "rounded" } })
      vim.api.nvim_create_autocmd("LspAttach", { callback = function(ev)
        local map = function(keys, func, desc) vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc }) end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")
      end })
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
      vim.lsp.config("jsonls", { settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } })
      vim.lsp.config("yamlls", { settings = { yaml = { schemaStore = { enable = false, url = "" }, schemas = require("schemastore").yaml.schemas() } } })
      for _, server in ipairs({ "lua_ls", "pyright", "ts_ls", "bashls", "gopls", "jsonls", "yamlls" }) do vim.lsp.enable(server) end
    end,
  },
  { "b0o/SchemaStore.nvim", lazy = false },
  { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" }, config = function()
      local cmp = require("cmp")
      local kind_labels = {
        Text = "Text", Method = "Method", Function = "Function", Constructor = "Constructor",
        Field = "Field", Variable = "Variable", Class = "Class", Interface = "Interface",
        Module = "Module", Property = "Property", Unit = "Unit", Value = "Value",
        Enum = "Enum", Keyword = "Keyword", Snippet = "Snippet", Color = "Color",
        File = "File", Reference = "Reference", Folder = "Folder", EnumMember = "Enum member",
        Constant = "Constant", Struct = "Struct", Event = "Event", Operator = "Operator",
        TypeParameter = "Type parameter",
      }
      local source_labels = { nvim_lsp = "[LSP]", luasnip = "[Snippet]", path = "[Path]", buffer = "[Buffer]" }
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(), ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" }, { name = "buffer" } }),
        formatting = { format = function(entry, item)
          item.kind = kind_labels[item.kind] or "Other"
          item.menu = source_labels[entry.source.name] or ""
          return item
        end },
      })
    end,
  },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { go = { "gofmt" }, lua = { "stylua" }, python = { "ruff_format" }, javascript = { "prettierd", "prettier" }, typescript = { "prettierd", "prettier" }, json = { "prettierd", "prettier" } }, format_on_save = { timeout_ms = 1000, lsp_format = "fallback" } } },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {
      delay = 300,
      preset = "modern",
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>r", group = "Refactor" },
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>d", group = "Debug" },
        { "<leader>T", group = "Tests" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>s", group = "Search and replace" },
        { "<leader>o", group = "Outline and tasks" },
        { "<leader>p", group = "Python" },
        { "<leader>q", group = "Sessions" },
        { "<leader>e", desc = "Toggle file explorer" },
        { "<leader>t", desc = "Toggle terminal" },
      },
    },
  },
})

return {
  { "mfussenegger/nvim-lint", event = { "BufReadPost", "BufNewFile" }, config = function()
      local lint = require("lint")
      lint.linters_by_ft = { go = { "golangcilint" }, python = { "ruff" }, javascript = { "eslint_d" }, typescript = { "eslint_d" }, javascriptreact = { "eslint_d" }, typescriptreact = { "eslint_d" }, yaml = { "yamllint" } }
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, { callback = function() lint.try_lint() end })
      vim.api.nvim_create_autocmd("BufWritePost", { pattern = { ".github/workflows/*.yml", ".github/workflows/*.yaml" }, callback = function() lint.try_lint("actionlint") end })
    end },
  { "williamboman/mason.nvim", opts = {} },
  -- Homebrew owns command-line formatters and linters. Mason owns editor-only tools.
  { "WhoIsSethDaniel/mason-tool-installer.nvim", dependencies = { "williamboman/mason.nvim" }, opts = { ensure_installed = { "debugpy", "js-debug-adapter" } } },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" }, opts = { ensure_installed = { "lua_ls", "pyright", "ts_ls", "bashls", "gopls", "jsonls", "yamlls" } } },
  { "neovim/nvim-lspconfig", dependencies = { "b0o/SchemaStore.nvim" }, config = function()
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
      vim.diagnostic.config({ virtual_text = true, severity_sort = true, float = { border = "rounded" } })
      vim.api.nvim_create_autocmd("LspAttach", { callback = function(ev)
        local map = function(keys, func, desc) vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc }) end
        map("gd", vim.lsp.buf.definition, "Go to definition"); map("gr", vim.lsp.buf.references, "References"); map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol"); map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic"); map("]d", vim.diagnostic.goto_next, "Next diagnostic")
      end })
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
      vim.lsp.config("jsonls", { settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } })
      vim.lsp.config("yamlls", { settings = { yaml = { schemaStore = { enable = false, url = "" }, schemas = require("schemastore").yaml.schemas() } } })
      for _, server in ipairs({ "lua_ls", "pyright", "ts_ls", "bashls", "gopls", "jsonls", "yamlls" }) do vim.lsp.enable(server) end
    end },
  { "b0o/SchemaStore.nvim", lazy = false },
  { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" }, config = function()
      local cmp = require("cmp")
      cmp.setup({ snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end }, mapping = cmp.mapping.preset.insert({ ["<C-Space>"] = cmp.mapping.complete(), ["<CR>"] = cmp.mapping.confirm({ select = true }), ["<Tab>"] = cmp.mapping.select_next_item(), ["<S-Tab>"] = cmp.mapping.select_prev_item() }), sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" }, { name = "buffer" } }) })
    end },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { go = { "gofmt" }, lua = { "stylua" }, python = { "ruff_format" }, javascript = { "prettierd", "prettier" }, typescript = { "prettierd", "prettier" }, json = { "prettierd", "prettier" } }, format_on_save = { timeout_ms = 1000, lsp_format = "fallback" } } },
}

return {
  { "folke/tokyonight.nvim", priority = 1000, config = function() vim.cmd.colorscheme("tokyonight-night") end },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = { options = { theme = "tokyonight" } } },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      local alpha, dashboard = require("alpha"), require("alpha.themes.dashboard")
      local function button(shortcut, label, command) return dashboard.button(shortcut, string.format("[%s] %s", shortcut, label), command) end
      dashboard.section.header.val = { "", "  66666   7777777 ", " 66          77   ", " 66666      77    ", " 66  66    77     ", "  66666   77      ", "" }
      dashboard.section.buttons.val = {
        button("f", "Find file", "<cmd>Telescope find_files<CR>"), button("r", "Recent files", "<cmd>Telescope oldfiles<CR>"),
        button("p", "Recent projects", "<cmd>Telescope repo list<CR>"), button("n", "New file", "<cmd>ene<CR>"),
        button("s", "Restore session", function() require("persistence").load() end), button("q", "Quit", "<cmd>qa<CR>"),
      }
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        return { "", string.format("Loaded %d plugins in %.2f ms", stats.count, stats.startuptime) }
      end
      dashboard.section.footer.opts.hl, dashboard.section.header.opts.hl, dashboard.section.buttons.opts.hl = "Comment", "Title", "Keyword"
      alpha.setup(dashboard.config)
    end },
  { "akinsho/toggleterm.nvim", version = "*", opts = { size = 15, open_mapping = [[<c-\\>]], direction = "horizontal", shade_terminals = true }, keys = { { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" } } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = { view = { width = 32, side = "left" }, renderer = { group_empty = true }, filters = { dotfiles = false }, update_focused_file = { enable = true } }, keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" } } },
  { "NeogitOrg/neogit", dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" }, opts = { integrations = { diffview = true, telescope = true } }, keys = { { "<leader>gg", "<cmd>Neogit<CR>", desc = "Git status" } } },
  { "sindrets/diffview.nvim", keys = { { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Git diff" }, { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Git diff" }, { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" } } },
  { "folke/trouble.nvim", opts = {}, keys = { { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" }, { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" }, { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list" }, { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" } } },
  { "folke/persistence.nvim", event = "BufReadPre", opts = {}, keys = { { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" }, { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" }, { "<leader>qd", function() require("persistence").stop() end, desc = "Stop session saving" } } },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {}, keys = { { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" } } },
  { "folke/flash.nvim", event = "VeryLazy", opts = {}, keys = { { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" }, { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" } } },
  { "echasnovski/mini.ai", version = false, opts = { n_lines = 500 } }, { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
  { "stevearc/aerial.nvim", opts = {}, keys = { { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle symbol outline" } } },
  { "MagicDuck/grug-far.nvim", opts = {}, keys = { { "<leader>sr", function() require("grug-far").open() end, desc = "Search and replace" }, { "<leader>sw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Replace word" } } },
  { "stevearc/overseer.nvim", opts = {}, keys = { { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run task" }, { "<leader>ot", "<cmd>OverseerToggle<CR>", desc = "Task list" } } },
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" }, opts = {}, dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" } },
  { "linux-cultist/venv-selector.nvim", dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" }, opts = {}, keys = { { "<leader>pv", "<cmd>VenvSelect<CR>", desc = "Select Python environment" } } },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" }, keys = { { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" }, { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search text" }, { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" } } },
  { "cljoly/telescope-repo.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, config = function() require("telescope").load_extension("repo") end, keys = { { "<leader>fp", "<cmd>Telescope repo list<CR>", desc = "Find projects" } } },
  { "lewis6991/gitsigns.nvim", opts = {} }, { "numToStr/Comment.nvim", opts = {} }, { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opts = { ensure_installed = { "bash", "css", "go", "gomod", "gosum", "gowork", "html", "javascript", "json", "lua", "markdown", "python", "tsx", "typescript", "vim", "yaml" }, highlight = { enable = true }, indent = { enable = true } } },
  { "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 4, mode = "cursor" } },
  { "folke/which-key.nvim", event = "VeryLazy", opts = { delay = 300, preset = "modern", spec = { { "<leader>f", group = "Find" }, { "<leader>r", group = "Refactor" }, { "<leader>c", group = "Code" }, { "<leader>g", group = "Git" }, { "<leader>d", group = "Debug" }, { "<leader>T", group = "Tests" }, { "<leader>x", group = "Diagnostics" }, { "<leader>s", group = "Search and replace" }, { "<leader>o", group = "Outline and tasks" }, { "<leader>p", group = "Python" }, { "<leader>q", group = "Sessions" }, { "<leader>e", desc = "Toggle file explorer" }, { "<leader>t", desc = "Toggle terminal" } } } },
}

-- All plugin specifications for lazy.nvim
return {
  -- UI & Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd("colorscheme tokyonight")
      -- Set Visual highlight color
      vim.api.nvim_set_hl(0, "Visual", { bg = "#1a5f7a", fg = "#ffffff" })
    end,
  },

  -- Plenary (needed early for R function)
  { "nvim-lua/plenary.nvim", lazy = false },

  -- Treesitter - Must be loaded early
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      pcall(function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "python", "cpp", "json", "yaml", "markdown" },
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
        })
      end)
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          preview = {
            treesitter = false,
          },
          file_ignore_patterns = {},
          path_display = { "smart" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
              width = function(_, max_columns, _)
                return math.min(max_columns, 120)
              end,
              height = function(_, _, max_lines)
                return math.min(max_lines, 30)
              end,
            },
          },
          winblend = 0,
          mappings = {
            i = {
              ["<C-p>"] = actions.preview_scrolling_up,
            },
            n = {
              ["p"] = actions.preview_scrolling_up,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  -- Tagbar - Fastest symbol navigation (uses ctags)
  {
    "preservim/tagbar",
    cmd = "TagbarToggle",
    keys = {
      {
        "<leader>s",
        function()
          vim.cmd("TagbarToggle")
        end,
        desc = "Toggle Tagbar",
      },
    },
    init = function()
      -- Cross-platform ctags path
      local ctags_path = "/usr/bin/ctags"
      if vim.fn.has("mac") == 1 then
        ctags_path = "/opt/homebrew/bin/ctags"  -- macOS ARM
      elseif vim.fn.has("macunix") == 1 then
        ctags_path = "/usr/local/bin/ctags"    -- macOS Intel
      end
      vim.g.tagbar_ctags_bin = ctags_path
      vim.g.tagbar_usearrows = 1
      vim.g.tagbar_autoshowtag = 0
      vim.g.tagbar_autofocus = 1
      vim.g.tagbar_verbose = 0
    end,
  },

  -- LSP
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("core.lsp").setup()
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { icons = false },
  },

  -- Harpoon 2
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon file" },
      { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon quick menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<C-s>", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- Refactoring
  {
    "theprimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Refactor",
    config = function()
      require("refactoring").setup()
    end,
  },

  -- Undotree
  { "mbbill/undotree", cmd = "UndotreeToggle" },

  -- Fugitive
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },

  -- Zen Mode
  { "folke/zen-mode.nvim", cmd = "ZenMode" },

  -- Copilot
  { "github/copilot.vim", event = "BufReadPost" },

  -- Cellular Automaton
  { "eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton" },

  -- Tmux Navigator (seamless Ctrl+hjkl navigation between tmux and vim)
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Cloak
  {
    "laytan/cloak.nvim",
    event = "BufReadPre",
    config = function()
      require("cloak").setup({
        enabled = false,
        cloak_character = "*",
        highlight_group = "Comment",
        patterns = {
          {
            file_pattern = { ".env*", "wrangler.toml", ".dev.vars" },
            cloak_pattern = "=.+",
          },
        },
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- UI Enhancements
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "rose-pine",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- File icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        default = true,
      })
    end,
  },

  -- Which-key (show keybindings popup)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        plugins = { spelling = true },
        win = {
          border = "rounded",
        },
      })
    end,
  },

  -- Noice (beautiful UI for cmdline, popup, notify)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      vim.notify = require("notify")
      vim.notify.setup({
        background_colour = "#000000",
        stages = "fade_in_slide_out",
        top_down = false,
        timeout = 3000,
        level = vim.log.levels.INFO, -- Show INFO, WARN, ERROR
      })

      -- Set highlight colors for notify
      vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#121214", default = true })
      vim.api.nvim_set_hl(0, "NotifyINFO", { bg = "#121214", fg = "#50fa7b", default = true })
      vim.api.nvim_set_hl(0, "NotifyWARN", { bg = "#121214", fg = "#f1fa8c", default = true })
      vim.api.nvim_set_hl(0, "NotifyERROR", { bg = "#121214", fg = "#ff5555", default = true })

      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
        },
        notify = {
          enabled = true,
          view = "notify",
        },
        routes = {
          {
            filter = {
              event = "notify",
              kind = nil,
            },
            opts = { position = "bottom-left" },
          },
          -- Filter Tagbar messages
          {
            filter = {
              event = "msg_show",
              find = "Tagbar",
            },
            opts = { skip = true },
          },
        },
      })
    end,
  },
}

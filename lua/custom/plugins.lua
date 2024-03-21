local plugins = {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
      ensure_installed = {
        "codelldb"
      }
    },
  },

  {
    'nvimdev/lspsaga.nvim',
    config = function()
        require('lspsaga').setup({})
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
    }
  },
  -- Nice, Noise, Notice!
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      }
  },
  { "nvim-neotest/nvim-nio" },
  { "folke/neodev.nvim", opts = {} },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require("core.utils").load_mappings("dap")
      local dap = require('dap')
      dap.configurations.cpp = {
        {
          name = "Launch with CLI args...",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          args = function()
            local arguments = vim.fn.input('Command line arguments: ')
            local t = {}
            for argument in string.gmatch(arguments, "%S+") do
              table.insert(t, argument)
            end
            return t
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
   -- 'dense-analysis/ale',
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- -- install without yarn or npm
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   ft = { "markdown" },
  --   build = function() vim.fn["mkdp#util#install"]() end,
  -- },
  --

  -- nu highlighting
  'LhKipp/nvim-nu',
  'jose-elias-alvarez/null-ls.nvim',
  "nvim-neotest/nvim-nio",

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "clangd",
        "clang-format",
        "codelldb",
        "pyright",
        "mypy",
        "ruff",
        "debugpy"
      }
    }
  },
  {
    "stevearc/aerial.nvim",
    lazy = true,
    cmd = {"AerialPrev", "AerialNext", "AerialToggle"},
    keys = {
      {"<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial"}
    },
    opts = {

    },
    -- config = function()
    --   require("aerial").setup({
    --     -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    --     on_attach = function(bufnr)
    --       -- Jump forwards/backwards with '{' and '}'
    --       vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    --       vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    --     end,
    --   })
    --
    --   -- You probably also want to set a keymap to toggle aerial
    --   vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    -- end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },


}



return plugins


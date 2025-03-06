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
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     lsp = {
  --       progress = {
  --         enabled = false,
  --       },
  --     },
  --     debug = true,
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --     }
  -- },
  --
{
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    views = {
      notify = {
        replace = true, -- Use nvim-notify for notifications
      },
    },
    lsp = {
      progress = {
        view = "notify",
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = { event = "msg_show" },
        opts = { skip = true } -- Avoids UI updates in fast event contexts
      },
      {
        filter = { event = "lsp", kind = "progress" },
        opts = { skip = true } -- Prevents LSP progress events from breaking UI
      },
    },
    throttle = 200, -- Reduce UI update frequency (Default is too fast)
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
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
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = 8123,
        executable = {
          command = "js-debug-adapter",
        }
      }
      for _, language in ipairs { "typescript", "javascript" } do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
          },
        }
      end
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
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   event = "VeryLazy",
  --   opts = function()
  --     return require "custom.configs.null-ls"
  --   end,
  -- },
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
  -- 'jose-elias-alvarez/null-ls.nvim',
  "nvim-neotest/nvim-nio",

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "js-debug-adapter",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
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
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      opts = require "plugins.configs.treesitter"
      opts.ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "rust"
      }
      return opts
    end
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

  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "brianhuster/autosave.nvim",
      -- Pick one of these pickers:
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      -- "echasnovski/mini.pick",
    },
    opts = {},
    event = "VeryLazy",  -- This is optional but recommended for lazy loading
  },

  {
    'tigion/nvim-asciidoc-preview',
    ft = { 'asciidoc' },
    build = 'cd server && npm install',
    opts = {
      server = {
        converter = 'js'
      },
      preview = {
        position = 'current',
      },
    },
  }

}

return plugins


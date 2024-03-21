local M = {}

vim.o.mousemoveevent = true

vim.keymap.set('n', '<leader>u', ':undo<CR>')

-- Define the keybinding to append a specific string to the current line
vim.keymap.set('n', '<C-a>', [[:lua vim.fn.append('.', ',rudolph.pienaar@childrens.harvard.edu')<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>j', '<ESC>v4jgq' )
vim.api.nvim_set_keymap('n', '<leader>at', ':ALEToggle<CR>', {noremap = true, silent = true})

vim.opt.clipboard = "unnamedplus"

-- disable virtual_text (inline) diagnostics and use floating window
-- format the message such that it shows source, message and
-- the error code. Show the message with <space>e
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = {
        border = "single",
        format = function(diagnostic)
            return string.format(
                "%s (%s) [%s]",
                diagnostic.message,
                diagnostic.source,
                diagnostic.code or diagnostic.user_data.lsp.code
            )
        end,
    },
})

vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<space>e', ':Lspsaga show_line_diagnostics<CR>', { noremap = true, silent = true })


M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dn"] = {
      "<cmd> DapStepOver<CR>",
      "Step to next line",
    },
    ["<leader>di"] = {
      "<cmd> DapStepInto<CR>",
      "Step into line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    }
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

return M

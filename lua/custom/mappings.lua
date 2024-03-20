local M = {}

vim.o.mousemoveevent = true

vim.keymap.set('n', '<leader>u', ':undo<CR>')

-- Define the keybinding to append a specific string to the current line
vim.keymap.set('n', '<C-a>', [[:lua vim.fn.append('.', ',rudolph.pienaar@childrens.harvard.edu')<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>j', '<ESC>v4jgq' )
vim.api.nvim_set_keymap('n', '<leader>at', ':ALEToggle<CR>', {noremap = true, silent = true})
vim.keymap.set("n", "<A-m>", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "? toggles local troubleshoot" })

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
                diagnostic.code 
            )
        end,
    },
})

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

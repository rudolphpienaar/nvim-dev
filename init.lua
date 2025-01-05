require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
local plugins = require "plugins"

require('lazy').setup(plugins)

-- Highlight trailing whitespace
vim.cmd('highlight ExtraWhitespace ctermbg=red guibg=red')
vim.cmd('match ExtraWhitespace /\\s\\+$/')

-- Define a command to strip trailing whitespace
vim.cmd('command! -bar StripWhiteSpace %s/\\s\\+$//e')

vim.api.nvim_create_user_command("CopyDiagnostics", function()
    -- Get the current line number
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    -- Retrieve diagnostics for the current line
    local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

    -- Open a new vertical split buffer
    vim.cmd("vnew")
    -- Get the current buffer ID for the new buffer
    local new_buf = vim.api.nvim_get_current_buf()

    -- Loop through diagnostics and add messages to the new buffer
    for _, diag in ipairs(diagnostics) do
        -- Split the diagnostic message into individual lines
        local lines = vim.split(diag.message, "\n", { plain = true })
        -- Append each line to the buffer
        vim.api.nvim_buf_set_lines(new_buf, -1, -1, false, lines)
    end
end, {})

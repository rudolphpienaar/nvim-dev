---@type ChadrcConfig
 local M = {}
 M.ui = { theme = 'catppuccin' }
 M.plugins = "custom.plugins"
 M.mappings = require("custom.mappings")
require("custom.noice_patch")
 return M

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")  -- Required for custom LSP registration

local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

-- Manually define Ruff LSP if it's not already registered
if not configs.ruff then
    configs.ruff = {
        default_config = {
            cmd = { "ruff", "server", "--preview" }, -- Explicitly use the Ruff LSP server
            filetypes = { "python" },
            root_dir = lspconfig.util.find_git_ancestor or lspconfig.util.path.dirname,
            single_file_support = true,
        },
    }
end

-- Setup TypeScript, Tailwind, and ESLint
lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities
})

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities
})

lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities
})

-- Clangd configuration
lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
})

-- Diagnostic configuration
vim.diagnostic.config({
    underline = true,
    signs = true,
    virtual_text = false,
    float = {
        show_header = true,
        source = 'if_many',
        border = 'rounded',
        focusable = false,
    },
    update_in_insert = false,
    severity_sort = false,
})

-- List of LSP servers
local servers = {
    "pyright",
    "ruff",  -- Ensure Ruff is listed here
}

-- Setup each server
for _, lsp in ipairs(servers) do
    if lspconfig[lsp] then
        lspconfig[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end
end


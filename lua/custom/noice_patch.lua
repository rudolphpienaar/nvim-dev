local function patch_noice()
    local progress_path = vim.fn.stdpath("data") .. "/lazy/noice.nvim/lua/noice/lsp/progress.lua"
    if vim.fn.filereadable(progress_path) == 1 then
        local lines = vim.fn.readfile(progress_path)

        -- Check if patch is already applied
        for _, line in ipairs(lines) do
            if line:match("if not data or not data.result then") then
                return
            end
        end

        -- Apply the patch
        table.insert(lines, 7, "    if not data or not data.result then return end") -- Insert after function definition
        vim.fn.writefile(lines, progress_path)
        print("Noice progress.lua patched to prevent nil 'result' errors")
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = "LazySyncPost",
    callback = patch_noice,
})


local function backup_noice_patch()
    local src = vim.fn.stdpath("data") .. "/lazy/noice.nvim/lua/noice/lsp/progress.lua"
    local dest = vim.fn.stdpath("config") .. "/noice_progress_patch.lua"

    if vim.fn.filereadable(src) == 1 then
        vim.fn.system({ "cp", src, dest })
        print("Noice progress.lua backed up.")
    end
end

local function restore_noice_patch()
    local src = vim.fn.stdpath("config") .. "/noice_progress_patch.lua"
    local dest = vim.fn.stdpath("data") .. "/lazy/noice.nvim/lua/noice/lsp/progress.lua"

    if vim.fn.isdirectory(vim.fn.fnamemodify(dest, ":h")) == 1 then
        vim.fn.system({ "cp", src, dest })
        print("Noice progress.lua restored from backup.")
    end
end

-- Automatically backup Noice patch after an update
vim.api.nvim_create_autocmd("User", {
    pattern = "LazySyncPost",
    callback = backup_noice_patch,
})

-- Restore Noice patch after startup if needed
vim.api.nvim_create_autocmd("VimEnter", {
    callback = restore_noice_patch,
})


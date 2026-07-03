-- ═══════════════════════════════════════════════════════════════════════════
-- Neovim init for the vscode-neovim extension (asvetliakov.vscode-neovim).
--
-- This is the REAL nvim engine embedded in VSCode. We deliberately do NOT load
-- AstroNvim here — VSCode owns the UI (statusline, file tree, completion,
-- treesitter highlighting). We only load the shared editing layer + wire
-- <leader> keys to native VSCode commands.
--
-- Motions/options come from lua/shared/editing.lua — the SAME source the full
-- Neovim config uses — so the two can never drift.
-- ═══════════════════════════════════════════════════════════════════════════

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Make our own lua/ modules requireable regardless of how nvim was launched.
local config = vim.fn.stdpath("config")
package.path = config .. "/lua/?.lua;" .. config .. "/lua/?/init.lua;" .. package.path

-- ── Shared editing layer (single source of truth) ────────────────────────────
require("shared.editing").apply()

-- ── Insert-mode escape ───────────────────────────────────────────────────────
-- Replicates better-escape.nvim (jj / jk → <Esc>), which is a plugin in the full
-- config and therefore not loaded here. VSCode-only; the real nvim uses the plugin.
local esc_opts = { noremap = true, silent = true }
vim.keymap.set("i", "jk", "<Esc>", esc_opts)
vim.keymap.set("i", "jj", "<Esc>", esc_opts)

-- ── <leader> bindings ─────────────────────────────────────────────────────────
-- Inherently VSCode-side (they call VSCode commands with no nvim equivalent), so
-- they can't live in shared/editing.lua. Each mirrors the SAME AstroNvim default
-- it stands in for — see ~/.local/share/nvim/lazy/AstroNvim/.../_astrocore_mappings.lua.
local vscode = require("vscode")
local function map(mode, lhs, id, desc)
  vim.keymap.set(mode, lhs, function() vscode.call(id) end,
    { noremap = true, silent = true, desc = desc })
end

-- Files / buffers / windows (mirror AstroNvim defaults)
map("n", "<Leader>w", "workbench.action.files.save",             "Save")             -- :w
map("n", "<Leader>n", "workbench.action.files.newUntitledFile",  "New File")         -- :enew
map("n", "<Leader>c", "workbench.action.closeActiveEditor",      "Close buffer")     -- close buffer
map("n", "<Leader>C", "workbench.action.revertAndCloseActiveEditor", "Force close buffer")
map("n", "<Leader>q", "workbench.action.closeActiveEditor",      "Quit Window")      -- :confirm q
map("n", "]b",        "workbench.action.nextEditor",             "Next buffer")      -- ]b
map("n", "[b",        "workbench.action.previousEditor",         "Previous buffer")  -- [b

-- Comment (AstroNvim: <Leader>/ = toggle comment, n + visual)
map("n", "<Leader>/", "editor.action.commentLine",  "Toggle comment line")
map("x", "<Leader>/", "editor.action.commentLine",  "Toggle comment")

-- Explorer (AstroNvim: <Leader>e = Toggle Explorer)
map("n", "<Leader>e", "workbench.view.explorer",    "Toggle Explorer")

-- Find (AstroNvim: ff files, fw words, fb buffers, fo old files)
map("n", "<Leader>ff", "workbench.action.quickOpen",     "Find files")
map("n", "<Leader>fw", "workbench.action.findInFiles",   "Find words")
map("n", "<Leader>fb", "workbench.action.showAllEditors","Find buffers")
map("n", "<Leader>fo", "workbench.action.openRecent",    "Find old files")

-- Git (AstroNvim: <Leader>gg = Lazygit; VSCode → SCM view)
map("n", "<Leader>gg", "workbench.view.scm",             "Git")

-- LSP (gd / gr / K are wired natively by vscode-neovim; these mirror <Leader>l*)
map("n", "<Leader>la", "editor.action.quickFix",         "Code action")
map("n", "<Leader>lr", "editor.action.rename",           "Rename")
map("n", "<Leader>lR", "editor.action.goToReferences",   "References")
map("n", "<Leader>lf", "editor.action.formatDocument",   "Format buffer")

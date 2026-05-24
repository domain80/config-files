-- Minimal Neovim init for vscode-neovim extension.
-- Motions: mirrors lua/plugins/mappings.lua — keep in sync when adding keymaps there.
-- Leader actions: call VSCode commands via require('vscode').call('command.id').

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local vscode = require("vscode")

local function cmd(id)
  return function() vscode.call(id) end
end

-- ── Motions ──────────────────────────────────────────────────────────────────

map({ "n", "v", "o" }, "H", "^", vim.tbl_extend("force", opts, { desc = "Go to first non-blank character" }))
map({ "n", "v", "o" }, "^", "H", vim.tbl_extend("force", opts, { desc = "Go to top of screen" }))
map({ "n", "v", "o" }, "L", "$", vim.tbl_extend("force", opts, { desc = "Go to end of line" }))
map({ "n", "v", "o" }, "$", "L", vim.tbl_extend("force", opts, { desc = "Go to bottom of screen" }))

-- ── Buffers / editors ─────────────────────────────────────────────────────────

map("n", "<leader>w",  cmd("workbench.action.closeActiveEditor"),      vim.tbl_extend("force", opts, { desc = "Close current editor" }))
map("n", "<leader>W",  cmd("workbench.action.closeAllEditors"),        vim.tbl_extend("force", opts, { desc = "Close all editors" }))
map("n", "]b",         cmd("workbench.action.nextEditor"),             vim.tbl_extend("force", opts, { desc = "Next editor tab" }))
map("n", "[b",         cmd("workbench.action.previousEditor"),         vim.tbl_extend("force", opts, { desc = "Prev editor tab" }))

-- ── Finding ───────────────────────────────────────────────────────────────────

map("n", "<leader>f",  cmd("workbench.action.quickOpen"),              vim.tbl_extend("force", opts, { desc = "Find files" }))
map("n", "<leader>ff", cmd("workbench.action.quickOpen"),              vim.tbl_extend("force", opts, { desc = "Find files" }))
map("n", "<leader>fg", cmd("workbench.action.findInFiles"),            vim.tbl_extend("force", opts, { desc = "Search in files (grep)" }))
map("n", "<leader>fb", cmd("workbench.action.showAllEditors"),         vim.tbl_extend("force", opts, { desc = "Find open buffers" }))
map("n", "<leader>fc", cmd("workbench.action.showCommands"),           vim.tbl_extend("force", opts, { desc = "Find commands" }))

-- ── Sidebar / panels ─────────────────────────────────────────────────────────

map("n", "<leader>e",  cmd("workbench.action.toggleSidebarVisibility"), vim.tbl_extend("force", opts, { desc = "Toggle sidebar" }))
map("n", "<leader>t",  cmd("workbench.action.terminal.toggleTerminal"), vim.tbl_extend("force", opts, { desc = "Toggle terminal" }))
map("n", "<leader>gs", cmd("workbench.view.scm"),                      vim.tbl_extend("force", opts, { desc = "Open git / SCM" }))

-- ── LSP (vscode-neovim wires gd/gr/K natively; these add extras) ─────────────

map("n", "<leader>ca", cmd("editor.action.quickFix"),                  vim.tbl_extend("force", opts, { desc = "Code actions" }))
map("n", "<leader>rn", cmd("editor.action.rename"),                    vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
map("n", "<leader>lr", cmd("editor.action.goToReferences"),            vim.tbl_extend("force", opts, { desc = "List references" }))

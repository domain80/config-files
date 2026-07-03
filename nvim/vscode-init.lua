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

-- ── VSCode-command bindings (these are inherently VSCode-side, not from nvim) ──
local vscode = require("vscode")
local opts = { noremap = true, silent = true }
local function cmd(id)
  return function() vscode.call(id) end
end
local function nmap(lhs, id, desc)
  vim.keymap.set("n", lhs, cmd(id), vim.tbl_extend("force", opts, { desc = desc }))
end

-- Buffers / editors
nmap("<leader>w",  "workbench.action.closeActiveEditor", "Close current editor")
nmap("<leader>W",  "workbench.action.closeAllEditors",   "Close all editors")
nmap("]b",         "workbench.action.nextEditor",        "Next editor tab")
nmap("[b",         "workbench.action.previousEditor",    "Prev editor tab")

-- Finding
nmap("<leader>f",  "workbench.action.quickOpen",         "Find files")
nmap("<leader>ff", "workbench.action.quickOpen",         "Find files")
nmap("<leader>fg", "workbench.action.findInFiles",       "Search in files (grep)")
nmap("<leader>fb", "workbench.action.showAllEditors",    "Find open buffers")
nmap("<leader>fc", "workbench.action.showCommands",      "Find commands")

-- Sidebar / panels
nmap("<leader>e",  "workbench.action.toggleSidebarVisibility", "Toggle sidebar")
nmap("<leader>t",  "workbench.action.terminal.toggleTerminal", "Toggle terminal")
nmap("<leader>gs", "workbench.view.scm",                       "Open git / SCM")

-- LSP (vscode-neovim wires gd/gr/K natively; these add extras)
nmap("<leader>ca", "editor.action.quickFix",           "Code actions")
nmap("<leader>rn", "editor.action.rename",             "Rename symbol")
nmap("<leader>lr", "editor.action.goToReferences",     "List references")

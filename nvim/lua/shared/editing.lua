-- ═══════════════════════════════════════════════════════════════════════════
-- Single source of truth for EDITING behaviour.
--
-- Everything here runs in the *real* Neovim engine in BOTH contexts:
--   • full Neovim          → consumed declaratively by AstroCore (see plugins/mappings.lua)
--   • vscode-neovim (VSCode) → applied imperatively by vscode-init.lua
--
-- Because both paths derive from THIS file, they can never drift.
--
-- ⚠ Only put things here that the nvim *engine* respects in both editors:
--   motions, operators, text-editing keymaps, engine options
--   (ignorecase/smartcase/iskeyword…).
--   DISPLAY options (number, relativenumber, wrap, signcolumn) are owned by
--   VSCode, not nvim — set those in VSCode settings.json instead.
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

-- Pure-vim keymaps. Each entry: { modes, lhs, rhs, desc }
-- These behave identically in Neovim and vscode-neovim.
M.keymaps = {
  { { "n", "v", "o" }, "H", "^", "Go to first non-blank character" },
  { { "n", "v", "o" }, "^", "H", "Go to top of screen" },
  { { "n", "v", "o" }, "L", "$", "Go to end of line" },
  { { "n", "v", "o" }, "$", "L", "Go to bottom of screen" },
}

-- Engine-level options that both editors honour. Add to this as you adopt more.
-- e.g. ignorecase = true, smartcase = true
M.options = {}

--- Build an AstroCore-style `mappings` table from M.keymaps.
--- Used by the full-Neovim config so it derives from the same source.
--- Shape: { n = { ["H"] = { "^", desc = ... }, ... }, v = {...}, o = {...} }
function M.astrocore_mappings()
  local out = {}
  for _, entry in ipairs(M.keymaps) do
    local modes, lhs, rhs, desc = entry[1], entry[2], entry[3], entry[4]
    for _, mode in ipairs(modes) do
      out[mode] = out[mode] or {}
      out[mode][lhs] = { rhs, desc = desc }
    end
  end
  return out
end

--- Imperatively apply the shared editing config to the running nvim instance.
--- Called by vscode-init.lua (there is no AstroCore in the VSCode context).
---
--- TODO(david): implement this — see the request in chat.
--- It should:
---   1. Set every option in M.options via `vim.opt`.
---   2. Register every keymap in M.keymaps via `vim.keymap.set`,
---      passing its `desc` and sensible opts ({ noremap = true, silent = true }).
function M.apply()
  -- 1. Engine-level options.
  for key, value in pairs(M.options) do
    vim.opt[key] = value
  end

  -- 2. Keymaps. `vim.keymap.set` accepts the modes list directly, so no inner
  --    loop is needed. `noremap = true` is what keeps the H↔^ / L↔$ swaps from
  --    recursing into each other; `silent = true` suppresses command echo.
  for _, entry in ipairs(M.keymaps) do
    local modes, lhs, rhs, desc = entry[1], entry[2], entry[3], entry[4]
    vim.keymap.set(modes, lhs, rhs, { noremap = true, silent = true, desc = desc })
  end
end

return M

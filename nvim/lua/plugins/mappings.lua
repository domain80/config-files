-- Motion keymaps are derived from the shared editing source so that full
-- Neovim and vscode-neovim can never drift. See lua/shared/editing.lua.
local editing = require "shared.editing"

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = editing.astrocore_mappings(),
  },
}

-- WezTerm Configuration
-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Automatically switch color scheme when macOS appearance changes
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "GitHub Dark"
  else
    return "One Light (base16)"
  end
end

wezterm.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

local appearance = (wezterm.gui and wezterm.gui.get_appearance()) or "Dark"
local is_dark = appearance:find("Dark") ~= nil

config.color_scheme = scheme_for_appearance(appearance)

-- Export COLORFGBG so apps that read it pick the right light/dark variant.
-- Claude Code's `auto` theme reads COLORFGBG's last field: 0-6 or 8 => dark,
-- 7 or 9-15 => light. WezTerm doesn't set this by default (iTerm2 does), which
-- is why `auto` never matched here. Applies to NEWLY spawned panes/sessions;
-- env vars can't change for an already-running process, so flip then open a
-- fresh tab (or relaunch claude) to get the matching theme.
config.set_environment_variables = {
  COLORFGBG = is_dark and "15;0" or "0;15",
}

-- Window size (~16:10 aspect ratio)
config.initial_cols = 135
config.initial_rows = 24

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16.0
config.line_height = 1.3

-- Enable the Kitty keyboard protocol so modified keys (e.g. Shift+Enter for a
-- newline) work in TUIs like Claude Code. Negotiated at session start, so open a
-- NEW window after changing this. (Does NOT affect the Up/Down-in-wrapped-prompt
-- bug — that's a Claude Code regression, #63670, not a terminal setting.)
config.enable_kitty_keyboard = true

return config

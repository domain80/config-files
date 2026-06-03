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

if wezterm.gui then
  config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
else
  config.color_scheme = "GitHub Dark"
end

-- Window size (~16:10 aspect ratio)
config.initial_cols = 135
config.initial_rows = 24

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16.0
config.line_height = 1.4

return config

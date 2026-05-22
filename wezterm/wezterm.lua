-- WezTerm Configuration
-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Window size (~16:10 aspect ratio)
config.initial_cols = 110
config.initial_rows = 17

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16.0
config.line_height = 1.4

return config

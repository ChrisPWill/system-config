local wezterm = require 'wezterm'

return {
  front_end = "WebGpu",

  font = wezterm.font {
    family = "FantasqueSansM Nerd Font Mono",
  },
  font_size = 16.0,
  color_scheme = "chrisTheme",
  window_background_opacity = 0.8,
  macos_window_background_blur = 20,
}

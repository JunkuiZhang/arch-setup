local wezterm = require 'wezterm';

return {
  color_scheme = "Catppuccin Frappe",
  font = wezterm.font_with_fallback({
	"Maple Mono SC NF",
	"Source Han Sans CN"
  }),
  font_size = 13,
  enable_tab_bar = false,
  window_background_opacity = 0.9,
}

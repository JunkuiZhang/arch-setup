local wezterm = require 'wezterm';

return {
  color_scheme = "Catppuccin",
  font = wezterm.font_with_fallback({
	"Ubuntu Mono Ligaturized",
--	"Hack",
	"Source Han Sans CN"
  }),
  font_size = 13,
  enable_tab_bar = false,
}

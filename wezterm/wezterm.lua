local wezterm = require 'wezterm'

return {
  -- Font - Use JetBrains Mono for better icon support
  font = wezterm.font('JetBrains Mono'),
  font_size = 12.0,

  -- Launch WSL Ubuntu (Oh My Posh will be loaded from .bashrc)
  default_prog = {
    'wsl.exe',
    '-d', 'Ubuntu',
  },

  colors = {
    background = '#00141a',
  },

  -- Window
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },
  window_background_opacity = 0.9,
  window_decorations = 'NONE',
  window_frame = {
    font = wezterm.font('JetBrains Mono', { weight = 'Bold' }),
    font_size = 12.0,
    inactive_titlebar_bg = '#000d1a',
    active_titlebar_bg = '#000d1a',
    inactive_titlebar_fg = '#21c7c7',
    active_titlebar_fg = '#21c7c7',
  },

  -- Tab bar
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  tab_bar_at_bottom = false,

  -- Cursor
  default_cursor_style = 'SteadyBlock',

  -- Scrollback
  scrollback_lines = 10000,

  -- WSL domains (accessible via tab)
  wsl_domains = {
    {
      name = 'WSL',
      distribution = 'Ubuntu',
    },
  },

  -- Misc
  adjust_window_size_when_changing_font_size = false,
  hide_tab_bar_if_only_one_tab = false,
  window_close_confirmation = 'NeverPrompt',
}

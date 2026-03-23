local wezterm = require 'wezterm'

local function get_default_prog()
  local sys = wezterm.system_detail()
  if sys.os_name == 'macOS' then
    return nil -- Use default shell on macOS
  elseif sys.os_name == 'Windows' then
    return { 'wsl.exe', '-d', 'Ubuntu' }
  else
    return nil -- Linux/WSL - use default shell
  end
end

return {
  -- Font - Use JetBrains Mono for better icon support
  font = wezterm.font('JetBrains Mono'),
  font_size = 12.0,

  -- Launch WSL Ubuntu on Windows, default shell elsewhere
  default_prog = get_default_prog(),

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

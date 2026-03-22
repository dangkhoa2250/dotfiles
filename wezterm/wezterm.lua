-- =============================================
-- WezTerm Configuration - Cross-platform (Windows/macOS)
-- =============================================

local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- Config table
local config = wezterm.config_builder()

-- =============================================
-- Platform Detection
-- =============================================

local is_windows = wezterm.target_triple:find 'windows' ~= nil
local is_macos = wezterm.target_triple:find 'darwin' ~= nil
local is_linux = wezterm.target_triple:find 'linux' ~= nil

-- =============================================
-- Appearance
-- =============================================

-- Color scheme
config.color_scheme = 'Catppuccin Mocha'

-- Font configuration with fallbacks
local font_name = 'JetBrainsMono Nerd Font'
local font_size = 13.0

-- Check if Nerd Font is available, fallback to system fonts
config.font = wezterm.font_with_fallback {
  font_name,
  'JetBrains Mono',
  'Fira Code',
  'SF Mono',
  'Menlo',
  'Monaco',
  'Courier New',
}

config.font_size = font_size

-- Window appearance
if is_macos then
  config.window_background_opacity = 0.92
  config.macos_window_background_blur = 20
  config.window_decorations = 'RESIZE'
  config.window_frame = {
    font = wezterm.font {
      family = font_name,
      weight = 'Bold',
    },
    font_size = font_size,
  }
else
  config.window_background_opacity = 0.95
  config.window_decorations = 'TITLE | RESIZE'
end

config.window_close_confirmation = 'NeverPrompt'

-- Window size
config.initial_cols = 120
config.initial_rows = 35

-- Padding
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- =============================================
-- Tab Bar
-- =============================================

config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

-- Tab colors
config.tab_bar_background = '#1e1e2e'
config.inactive_tab_edge_hinter_color = '#45475a'

-- =============================================
-- Scrollback
-- =============================================

config.scrollback_lines = 10000
config.scrollback_eager_scroll_size = 0

-- =============================================
-- Mouse & Selection
-- =============================================

config.audible_bell = 'Disabled'
config.selection_word_boundary = ' \t\n{}[]()""\'`,;│=+'

-- =============================================
-- Key Bindings
-- =============================================

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Build keys table based on platform
local keys = {
  -- Split panes
  {
    key = '|',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- Navigate panes
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },

  -- Resize panes
  {
    key = 'H',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'L',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'K',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'J',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Down', 5 },
  },

  -- Tabs
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'LEADER', action = act.CloseCurrentTab { confirm = false } },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
  { key = '0', mods = 'LEADER', action = act.ActivateTab(9) },

  -- Zoom pane
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- Reload config
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ReloadConfiguration,
  },

  -- Copy mode
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Clear scrollback
  {
    key = 'K',
    mods = 'LEADER',
    action = act.ClearScrollback 'ScrollbackAndViewport',
  },
}

-- Platform-specific key bindings
if is_windows then
  -- Windows: Copy to clipboard with Ctrl+Shift
  table.insert(keys, {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = act.CopyToClipboard { selection = 'Clipboard' },
  })
  table.insert(keys, {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = act.PasteFromClipboard,
  })
elseif is_macos then
  -- macOS: Use Command key for copy/paste
  table.insert(keys, {
    key = 'c',
    mods = 'CMD',
    action = act.CopyToClipboard { selection = 'Clipboard' },
  })
  table.insert(keys, {
    key = 'v',
    mods = 'CMD',
    action = act.PasteFromClipboard,
  })
  -- Also support Cmd+Shift+C/V
  table.insert(keys, {
    key = 'c',
    mods = 'CMD|SHIFT',
    action = act.CopyToClipboard { selection = 'Clipboard' },
  })
  table.insert(keys, {
    key = 'v',
    mods = 'CMD|SHIFT',
    action = act.PasteFromClipboard,
  })
end

config.keys = keys

-- =============================================
-- Launch Menu (Windows - WSL only)
-- =============================================

if is_windows then
  config.default_domain = 'WSL:Ubuntu'

  config.domains = {
    wezterm.domain {
      name = 'WSL:Ubuntu',
      kind = 'WSL',
      distribution = 'Ubuntu',
    },
  }

  config.launch_menu = {
    {
      label = 'WSL: Ubuntu',
      domain = { DomainName = 'WSL:Ubuntu' },
    },
    {
      label = 'PowerShell',
      args = { 'pwsh.exe', '-NoLogo' },
    },
    {
      label = 'Command Prompt',
      args = { 'cmd.exe' },
    },
  }
end

-- =============================================
-- Hyperlink Rules
-- =============================================

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- =============================================
-- Return config
-- =============================================

return config

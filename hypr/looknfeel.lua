-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Catppuccin Mocha
hl.config({
  general = {
    border_size = 2,
    gaps_in = 5,
    gaps_out = 10,
    col = {
      active_border = "rgb(cba6f7)",   -- mauve
      inactive_border = "rgb(313244)", -- surface0
    },
  },

  decoration = {
    rounding = 12,

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      noise = 0.02,
      contrast = 0.9,
      brightness = 0.85,
      popups = true,
    },

    shadow = {
      enabled = true,
      range = 20,
      render_power = 3,
      color = "rgba(1e1e2ebb)",
    },
  },

  group = {
    col = {
      border_active = "rgb(cba6f7)",   -- mauve
      border_inactive = "rgb(313244)", -- surface0
    },
  },

  misc = {
    background_color = "rgb(1e1e2e)", -- base
  },
})

-- Sin blur en waybar: el fondo debe ser completamente transparente
-- (el blur del compositor haría visible el área detrás de las pills)

-- Forzar tema GTK oscuro en todas las apps
hl.env("GTK_THEME", "catppuccin-mocha-mauve-standard+default")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")

-- Battle.net / Wine: prevent ghost windows from stealing focus.
o.window({ class = "steam_app_default", title = "^$" }, { no_focus = true })

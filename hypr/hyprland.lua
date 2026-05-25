-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Load user modules from ~/.config and Omarchy defaults from $OMARCHY_PATH.
package.path = os.getenv("HOME")
  .. "/.config/?.lua;"
  .. (os.getenv("OMARCHY_PATH") or (os.getenv("HOME") .. "/.local/share/omarchy"))
  .. "/?.lua;"
  .. package.path

-- All Omarchy default setups
require("default.hypr.omarchy")

-- Change your own setup in these files and override defaults.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Terminales: más diferencia entre activa/inactiva (override del default de Omarchy 0.97/0.90)
o.window("(Alacritty|kitty|com.mitchellh.ghostty|foot)", { opacity = "0.97 0.78" })

-- Steam: forzar modo mosaico (sobreescribe el float=true del default de Omarchy)
o.window({ class = "^steam$", title = "^Steam$" }, { tile = true })

-- Steam Friends List: limitar tamaño al abrir
o.window({ class = "^steam$", title = "^Friends List$" }, { float = true, size = { 360, 850 }, center = true })

-- Calendario emergente de waybar (click en la fecha)
o.window("calendar-popup.*", {
  float = true,
  move  = { "325", "57" },
  pin   = true,
})

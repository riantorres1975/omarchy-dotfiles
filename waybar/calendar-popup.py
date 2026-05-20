#!/usr/bin/env python3
import gi, sys
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, Gio

CSS = b"""
window {
    background-color: #11111b;
    border-radius: 12px;
    border: 1.5px solid #313244;
}
calendar {
    background-color: #11111b;
    color: #cdd6f4;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 13px;
    border-radius: 8px;
    padding: 6px;
}
calendar:selected {
    background-color: #cba6f7;
    color: #1e1e2e;
    border-radius: 6px;
}
calendar.header {
    background: transparent;
    color: #b4befe;
    font-weight: bold;
    font-size: 14px;
}
calendar.button, calendar.highlight {
    color: #cba6f7;
    background: transparent;
}
calendar:indeterminate {
    color: #45475a;
}
"""

class CalendarApp(Gtk.Application):
    def __init__(self):
        super().__init__(
            application_id="waybar.calendar",
            flags=Gio.ApplicationFlags.NON_UNIQUE
        )

    def do_activate(self):
        provider = Gtk.CssProvider()
        provider.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        win = Gtk.ApplicationWindow(application=self)
        win.set_decorated(False)
        win.set_resizable(False)
        win.set_keep_above(True)
        win.set_skip_taskbar_hint(True)
        win.set_skip_pager_hint(True)

        cal = Gtk.Calendar()
        cal.set_display_options(
            Gtk.CalendarDisplayOptions.SHOW_HEADING |
            Gtk.CalendarDisplayOptions.SHOW_DAY_NAMES |
            Gtk.CalendarDisplayOptions.SHOW_WEEK_NUMBERS
        )
        win.add(cal)

        win.connect("key-press-event", lambda w, e: self.quit() if e.keyval == Gdk.KEY_Escape else None)

        from gi.repository import GLib
        def connect_focus_out():
            win.connect("focus-out-event", lambda w, e: self.quit())
            return False
        GLib.timeout_add(400, connect_focus_out)

        win.show_all()

app = CalendarApp()
app.run(sys.argv)

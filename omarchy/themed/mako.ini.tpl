include=~/.local/share/omarchy/default/mako/core.ini
include=~/.local/state/omarchy/toggles/mako.ini

background-color={{ background }}e6
text-color={{ cursor }}
border-color={{ accent }}
border-size=1
border-radius=12
width=380
padding=14,18
outer-margin=16,22
font=sans-serif 13px
max-icon-size=40

progress-color=over {{ accent }}40

[urgency=low]
background-color={{ background }}cc
border-color={{ color8 }}
text-color={{ foreground }}

[urgency=normal]
background-color={{ background }}e6
border-color={{ accent }}
text-color={{ cursor }}

[urgency=critical]
background-color={{ background }}f2
border-color={{ color1 }}
text-color={{ color1 }}
default-timeout=0

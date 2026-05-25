return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#08030A",
        dark_bg    = "#060208",
        darker_bg  = "#040205",
        lighter_bg = "#211c23",

        fg         = "#EEF1F4",
        dark_fg    = "#b3b5b7",
        light_fg   = "#f1f3f6",
        bright_fg  = "#f2f5f7",
        muted      = "#6a666b",

        red        = "#a26f69",
        yellow     = "#E9DE00",
        orange     = "#b08580",
        green      = "#64834a",
        cyan       = "#7EABAA",
        blue       = "#617dbe",
        purple     = "#7177c0",
        brown      = "#6a504d",

        bright_red    = "#cc9189",
        bright_yellow = "#fbee00",
        bright_green  = "#84aa5d",
        bright_cyan   = "#9fd2d1",
        bright_blue   = "#839ff3",
        bright_purple = "#9598f5",

        accent               = "#617dbe",
        cursor               = "#EEF1F4",
        foreground           = "#EEF1F4",
        background           = "#08030A",
        selection             = "#211c23",
        selection_foreground = "#EEF1F4",
        selection_background = "#211c23",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}

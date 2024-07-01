{
  pkgs,
  lib,
  theme,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      window = {
        option_as_alt = lib.mkIf pkgs.stdenv.isDarwin "OnlyLeft";
        opacity = 0.8;
        decorations_theme_variant = "Dark";
        decorations = "none";
      };
      colors = {
        primary = {
          background = theme.background;
          foreground = theme.foreground;
        };
        normal = with theme.normal; {
          black = black;
          white = white;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          cyan = cyan;
          magenta = magenta;
        };
        bright = with theme.light; {
          black = black;
          white = white;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          cyan = cyan;
          magenta = magenta;
        };
      };
      scrolling.history = 20000;
      font = {
        normal.family = "FantasqueSansM Nerd Font Mono";
        size = 20.0;
      };
      cursor = {
        style.shape = "Beam";
        style.blinking = "On";
        vi_mode_style.shape = "Block";
        vi_mode_style.blinking = "On";
      };
      selection.save_to_clipboard = true;
    };
  };
}

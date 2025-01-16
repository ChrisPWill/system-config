{
  theme,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    colorSchemes = {
      chrisTheme = {
        background = theme.background;
        foreground = theme.foreground;
        cursor_bg = theme.light.silver;
        cursor_fg = theme.light.black;
        cursor_border = theme.light.silver;

        split = theme.normal.silver;
        scrollbar_thumb = theme.light.silver;

        ansi = with theme.normal; [
          black
          red
          green
          yellow
          blue
          magenta
          cyan
          silver
        ];
        brights = with theme.light; [
          gray
          red
          green
          yellow
          blue
          magenta
          cyan
          silver
        ];
      };
    };

    extraConfig = builtins.readFile (with pkgs; (replaceVars ./wezterm.lua {inherit nushell;}));
  };
}

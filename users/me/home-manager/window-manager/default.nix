{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix # window manager
    ./lock.nix # swaylock, hypridle
    ./widgets.nix # widgets
  ];

  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      brightnessctl
      libnotify
      wlsunset
    ];

    services.flameshot.enable = true;

    # notifications
    services.swaync.enable = true;
  };
}

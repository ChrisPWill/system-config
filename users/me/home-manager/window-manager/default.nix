{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix # window manager
    ./lock.nix # swaylock, hypridle
  ];

  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      brightnessctl
      libnotify
    ];

    services.flameshot.enable = true;

    # notifications
    services.swaync.enable = true;
  };
}

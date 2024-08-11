{
  pkgs,
  lib,
  config,
  ...
}: let
  agsHomePath = "${config.home.homeDirectory}/.dotfiles/users/me/home-manager/window-manager/ags-widgets";
in {
  imports = [
    (import ./hyprland.nix {agsHomePath = agsHomePath;}) # window manager
    ./lock.nix # swaylock, hypridle
    (import ./widgets.nix {agsHomePath = agsHomePath;}) # widgets
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

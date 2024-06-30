{
  pkgs,
  lib,
  theme,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    wayland.windowManager.hyprland = {
      enable = true;
      # enableNvidiaPatches = true;
      extraConfig = import ./hyprlandExtraConfig.nix {inherit pkgs theme;};
    };
  };
}

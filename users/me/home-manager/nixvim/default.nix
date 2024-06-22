{
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ./plugins/default.nix {utils = import ./utils.nix {};})
  ];

  options = {
    programs.nixvim.custom = {
      enableCopilot = lib.mkEnableOption "Enable Copilot in Neovim";
    };
  };

  config.programs.nixvim = {
    enable = true;
    defaultEditor = true;

    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = pkgs.stdenv.isLinux;
    clipboard.providers.wl-copy.package = pkgs.wl-clipboard-rs;

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
    };
  };
}

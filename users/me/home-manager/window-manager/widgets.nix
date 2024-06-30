{
  pkgs,
  lib,
  inputs,
  config,
  system,
  ...
}: let
  deps = with pkgs; [
    # Extends the standard GTK widget for multiline text editing
    # to allow syntax highlighting, undo/redo, file loading, etc.
    # https://gitlab.gnome.org/GNOME/gtksourceview
    gtksourceview

    # GTK+ port of webkit
    # https://webkitgtk.org/
    webkitgtk

    # D-Bus service for accessing list of user accounts/info associated
    accountsservice

    # for bundling Typescript-based config
    bun
  ];
in {
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [
    ];
    # Aylur's GTK Shell widgets https://aylur.github.io/ags-docs/
    programs.ags = {
      enable = true;

      configDir = null;

      extraPackages = deps;

      package = inputs.ags.packages.${system}.agsWithTypes.overrideAttrs {
        postFixup = ''
          wrapProgram $out/bin/ags --prefix PATH : ${lib.makeBinPath deps}
        '';
      };
    };

    xdg.configFile."ags".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/users/me/home-manager/window-manager/ags-widgets";
  };
}

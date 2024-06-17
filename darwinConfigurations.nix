{nix-darwin, ...}: let
  mkDarwinConfig = {
    hostname,
    system,
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./hardware/${hostname}.nix
        ./shared-modules/home-manager-defaults.nix
      ];
    };
in {
  cwilliams-work-laptop = mkDarwinConfig {
    hostname = "cwilliams-work-laptop";
    system = "aarch64-darwin";
  };
}

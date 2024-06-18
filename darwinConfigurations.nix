inputs @ {nix-darwin, ...}: let
  mkDarwinConfig = {
    hostname,
    system,
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hardware/${hostname}.nix
      ];
    };
in {
  cwilliams-work-laptop = mkDarwinConfig {
    hostname = "cwilliams-work-laptop";
    system = "aarch64-darwin";
  };
}

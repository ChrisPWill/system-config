inputs @ {nixpkgs, ...}: let
  system = "x86_64-linux";
  mkNixosConf = {hostname}:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
      };
      modules = [
        ./hardware/${hostname}.nix
        (import ./modules/nixos-defaults.nix {inherit system;})
      ];
    };
in {
  personal-pc = mkNixosConf {
    hostname = "personal-pc";
  };
  personal-vm = mkNixosConf {
    hostname = "personal-vm";
  };
}

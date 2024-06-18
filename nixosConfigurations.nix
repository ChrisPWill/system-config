inputs @ {nixpkgs, ...}: let
  mkNixosConf = {hostname}:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hardware/${hostname}.nix
        ./modules/nixos-defaults.nix
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

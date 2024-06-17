{nixpkgs, ...}: let
  mkNixosConf = hostname:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/${hostname}.nix
        ./shared-modules/nixos-defaults.nix
        ./shared-modules/home-manager-defaults.nix
      ];
    };
in {
  personal-pc = mkNixosConf "personal-pc";
  personal-vm = mkNixosConf "personal-vm";
}

{
  nixpkgs,
  home-manager,
  nixvim,
  ...
}: let
  mkNixosConf = {hostname}:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/${hostname}.nix
        ./modules/nixos-defaults.nix

        # Home Manager setup
        home-manager.nixosModules.home-manager
        ./modules/home-manager-defaults.nix
        ./users/mainUser.nix

        # Neovim
        nixvim.nixosModules.nixvim
        nixvim.homeManagerModules.nixvim
        ./modules/nixvim/default.nix
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

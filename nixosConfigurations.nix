inputs @ {
  nixpkgs,
  home-manager,
  nixvim,
  ...
}: let
  home-manager-module = home-manager.nixosModules.home-manager;
  nixvim-module = nixvim.nixosModules.nixvim;
  mkNixosConf = {hostname}:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        home-manager = home-manager-module;
        nixvim = nixvim-module;
      };
      modules = [
        ./hardware/${hostname}.nix
        ./modules/nixos-defaults.nix

        # Home Manager setup
        home-manager-module
        ./modules/home-manager-defaults.nix
        ./users/mainUser.nix

        # Neovim
        nixvim-module
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

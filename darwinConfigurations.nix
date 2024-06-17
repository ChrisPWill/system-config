{
  nix-darwin,
  home-manager,
  nixvim,
  ...
}: let
  mkDarwinConfig = {
    hostname,
    system,
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./hardware/${hostname}.nix

        # Home Manager setup
        home-manager.darwinModules.home-manager
        ./modules/home-manager-defaults.nix
        ./users/mainUser.nix

        # Neovim
        nixvim.nixDarwinModules.nixvim
        nixvim.homeManagerModules.nixvim
        ./modules/nixvim/default.nix
      ];
    };
in {
  cwilliams-work-laptop = mkDarwinConfig {
    hostname = "cwilliams-work-laptop";
    system = "aarch64-darwin";
  };
}

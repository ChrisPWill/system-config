inputs @ {
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
}: let
  theme = import ./utils/theme.nix;
  mkDarwinConfig = {
    hostname,
    system,
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
        inherit theme;
      };
      modules = [
        ./hardware/${hostname}.nix
        {
          nixpkgs.config.allowUnfree = true;
        }
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs nixpkgs theme;};
          };
        }
        ./users/me
      ];
    };
in {
  cwilliams-work-laptop = mkDarwinConfig {
    hostname = "cwilliams-work-laptop";
    system = "aarch64-darwin";
  };
}

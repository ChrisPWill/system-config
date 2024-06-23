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
    stateVersion,
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
        inherit theme;
      };
      modules = [
        ./hosts/${hostname}
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
        (import ./users/me {inherit stateVersion;})
        (import ./darwin {})
      ];
    };
in {
  cwilliams-work-laptop-aarch64darwin = mkDarwinConfig {
    hostname = "cwilliams-work-laptop-aarch64darwin";
    system = "aarch64-darwin";
    stateVersion = "23.11";
  };
}

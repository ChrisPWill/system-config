inputs @ {
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
}: let
  mkDarwinConfig = {
    hostname,
    system,
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
      };
      modules = [
        ./hardware/${hostname}.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs nixpkgs;};
          };

          # me
          users.users.cwilliams = {
            isNormalUser = true;
            description = "Chris Williams";
            extraGroups = [
              "audio"
              "docker"
              "networkmanager"
              "wheel"
            ];
          };
          home-manager.users.cwilliams = import ./users/me.nix {};
        }
      ];
    };
in {
  cwilliams-work-laptop = mkDarwinConfig {
    hostname = "cwilliams-work-laptop";
    system = "aarch64-darwin";
  };
}

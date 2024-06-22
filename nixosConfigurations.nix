inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  theme = import ./utils/theme.nix;
  mkNixosConf = {
    hostname,
    stateVersion,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
        inherit theme;
      };
      modules = [
        ./hosts/${hostname}
        ./hosts/personalMachine.nix
        {
          nixpkgs.config.allowUnfree = true;
        }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs nixpkgs theme;};
          };
        }
        (import ./users/me {inherit stateVersion;})
        (import ./nixos {})
      ];
    };
in {
  personal-pc-x64linux = mkNixosConf {
    hostname = "personal-pc-x64linux";
    stateVersion = "23.11";
  };
  personal-vm = mkNixosConf {
    hostname = "personal-vm";
    stateVersion = "24.05";
  };
}

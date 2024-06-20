inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  theme = import ./utils/theme.nix;
  mkNixosConf = {hostname}:
    nixpkgs.lib.nixosSystem {
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
        home-manager.nixosModules.home-manager
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
  personal-pc = mkNixosConf {
    hostname = "personal-pc";
  };
  personal-vm = mkNixosConf {
    hostname = "personal-vm";
  };
}

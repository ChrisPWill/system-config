inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  mkNixosConf = {hostname}:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
      };
      modules = [
        ./hardware/${hostname}.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs nixpkgs;};

          # me
          users.users.cwilliams.isNormalUser = true;
          home-manager.users.cwilliams = import ./users/me.nix {};
        }
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

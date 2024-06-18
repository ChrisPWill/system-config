inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  mkNixosConf = {hostname}: let
    pkgUtils = import utils/packages.nix;
    pkgs = pkgUtils.getPkgs {inherit system nixpkgs;};
  in
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
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs nixpkgs;};
          };

          # me
          programs.zsh.enable = true;
          users.users.cwilliams = {
            isNormalUser = true;
            description = "Chris Williams";
            shell = pkgs.zsh;
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
  personal-pc = mkNixosConf {
    hostname = "personal-pc";
  };
  personal-vm = mkNixosConf {
    hostname = "personal-vm";
  };
}

inputs @ {
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
}: let
  mkDarwinConfig = {
    hostname,
    system,
  }: let
    pkgUtils = import utils/packages.nix;
    pkgs = pkgUtils.getPkgs {inherit system nixpkgs;};
  in
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
          programs.zsh.enable = true;
          users.users.cwilliams = {
            description = "Chris Williams";
            shell = pkgs.zsh;
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

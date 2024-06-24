inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  theme = import ./utils/theme.nix;
  pkgUtil = import ./utils/packages.nix;
  mkHomeConfig = {
    stateVersion ? "24.05",
    system,
    ...
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgUtil.getPkgs {inherit nixpkgs system;};
      extraSpecialArgs = {inherit inputs theme;};
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
        }
        (import ./users/me/home-manager {inherit stateVersion;})
      ];
    };
in {
  "cwilliams@cwilliams-work-laptop-aarch64darwin" = mkHomeConfig {
    stateVersion = "23.11";
    system = "aarch64-darwin";
  };
  "cwilliams@personal-pc-x64linux" = mkHomeConfig {
    stateVersion = "24.05";
    system = "x86_64-linux";
  };
}

{system}: {nixpkgs, ...}: let
  sharedUtils = import ../utils/packages.nix;
  pkgs = sharedUtils.getPkgs {inherit nixpkgs system;};
in {
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}

{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  virtualisation.docker = {
    enableNvidia = true;
    enable = true;
  };
}

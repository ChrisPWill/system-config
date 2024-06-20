{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./configuration.nix
  ];

  isPersonalMachine = true;

  virtualisation.docker = {
    enableNvidia = true;
    enable = true;
  };
}

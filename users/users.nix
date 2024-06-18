{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.zsh.enable = true;
  users.users.cwilliams = {
    isNormalUser = true;
    description = "Chris Williams";
    shell = pkgs.zsh;
    extraGroups =
      [
        "wheel"
      ]
      ++ lib.optionals config.virtualisation.docker.enable [
        "docker"
      ]
      ++ lib.optionals config.networking.networkmanager.enable [
        "networkmanager"
      ]
      ++ lib.optionals config.sound.enable [
        "audio"
      ];
  };
  home-manager.users.cwilliams = import ./me/home-manager {};
}

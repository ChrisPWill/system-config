{
  stateVersion ? "24.05",
}: {
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
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
    home-manager.users.cwilliams = import ./home-manager {inherit stateVersion;};
  };
}

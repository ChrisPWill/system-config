{
  stateVersion ? "24.05",
  extraHomeModules ? [],
}: {
  pkgs,
  config,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
in {
  config = with lib; {
    programs.zsh.enable = true;
    users.users.cwilliams = mkMerge [
      # Common attrs
      {
        description = "Chris Williams";
        shell = pkgs.nushell;
      }
      (
        if isLinux
        then {
          # Linux only options
          isNormalUser = true;
          extraGroups =
            ["wheel"]
            ++ (optionals isLinux ["audio"])
            ++ (optionals (isLinux && config.virtualisation.docker.enable) ["docker"])
            ++ (optionals (isLinux && config.networking.networkmanager.enable) ["networkmanager"])
            ++ (optionals (isLinux && config.virtualisation.libvirtd.enable) ["libvirtd"]);
        }
        else {
          home = "/Users/cwilliams";
        }
      )
    ];
    home-manager.users.cwilliams = import ./home-manager {
      inherit stateVersion extraHomeModules;
      isPersonalMachine = config.isPersonalMachine;
    };
  };
}

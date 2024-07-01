{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.isPersonalMachine {
    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
    };
  };
}

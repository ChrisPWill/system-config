{config, lib, ...}: {
  options = {
    isPersonalMachine = lib.mkOption{
    type = lib.types.bool;
      description = "Enable things I only want on my personal machine";
      default = false;
    };
  };

  config = lib.mkIf config.isPersonalMachine {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
}

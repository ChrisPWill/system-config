{lib, ...}: {
  options = {
    isPersonalMachine = lib.mkOption {
      type = lib.types.bool;
      description = "Enable things I only want on my personal machine";
      default = false;
    };
    isWsl = lib.mkOption {
      type = lib.types.bool;
      description = "Enable/disable things relevant to WSL";
      default = false;
    };

  };
}

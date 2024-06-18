{lib, ...}: {
  imports = [
    ./plugins/default.nix
  ];

  options = {
    programs.nixvim.custom = {
      enableCopilot = lib.mkEnableOption "Enable Copilot in Neovim";
    };
  };

  config.programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}

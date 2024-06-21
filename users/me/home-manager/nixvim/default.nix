{lib, ...}: {
  imports = [
    (import ./plugins/default.nix { utils = import ./utils.nix {}; })
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

{
  me ? "cwilliams",
  stateVersion ? "24.05",
}: {inputs, ...}
: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home = {
    username = me;
    stateVersion = stateVersion;
  };
  programs.home-manager.enable = true;

  programs.nixvim = {
    enable = true;
  };
}

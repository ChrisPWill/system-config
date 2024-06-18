{
  config,
  home-manager,
  nixvim,
  ...
}: {
  imports = [home-manager nixvim];

  home-manager.users.${config.mainUsername}.programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}

{config, ...}: {
  home-manager.users.${config.mainUser}.programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}

{config}: {
  enable = true;
  userName = config.home.fullName;
  userEmail = config.home.email;
  lfs.enable = true;
  extraConfig = {
    push.autoSetupRemote = true;
  };
}

{config, ...}: {
  programs.git = {
    enable = true;
    userName = config.home.fullName;
    userEmail = config.home.email;
    lfs.enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
      core = {
        # Improved performance on MacOS
        # https://github.blog/2022-06-29-improve-git-monorepo-performance-with-a-file-system-monitor/
        fsmonitor = true;
        untrackedcache = true;
      };
    };
  };
}

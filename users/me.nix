{
  username ? "cwilliams",
  stateVersion ? "24.05",
}: {...}
: {
  home = {
    username = username;
    stateVersion = stateVersion;
  };
  programs.home-manager.enable = true;
}

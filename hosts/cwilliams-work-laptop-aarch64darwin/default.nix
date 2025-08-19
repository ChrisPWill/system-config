{...}: {
  imports = [];

  system.stateVersion = 4;
  homebrew = {
    taps = [
      "atlassian/homebrew-acli"
      {
        name = "atlassian/cloudtoken";
        clone_target = "git@bitbucket.org:atlassian/cloudtoken-homebrew-tap.git
";
        force_auto_update = true;
      }
    ];
    brews = [
      "acli"
    ];
    casks = [
      "google-drive"
      "loom"

      # For work
      "cloudtoken"
    ];
  };
}

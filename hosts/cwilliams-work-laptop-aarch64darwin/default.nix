{...}: {
  imports = [];

  system.stateVersion = 4;
  homebrew = {
    casks = [
      "loom"
    ];
  };
  isPersonalMachine = false;
}

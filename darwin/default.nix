{...}: {pkgs, ...}: {
  nix.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Auto upgrade nix package
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    casks = [
      "alacritty"
      "amethyst"
      "docker"
      "firefox"
      "firefox@developer-edition"

      # Another modern terminal replacement
      "ghostty"

      "insomnia"
      "obsidian"
      "raycast"
      "scroll-reverser"
      "spotify"
      "visual-studio-code"
      "nikitabobko/tap/aerospace"

      # A notes app, more for outlining than obsidian
      "logseq"

      # Keystroke overlay for demos
      "keycastr"

      # AI coder
      "cursor"
    ];
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  system.defaults = {
    screencapture = {
      location = "/tmp";
    };
    dock = {
      autohide = true;
      autohide-delay = 0.2;
      autohide-time-modifier = 2.0;
      mru-spaces = false;
      showhidden = true;
      show-recents = false;
      static-only = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      QuitMenuItem = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      AppleFontSmoothing = 1;
      _HIHideMenuBar = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 1;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.swipescrolldirection" = true;
    };

    trackpad = {
      Clicking = true; # tap to click
      TrackpadRightClick = true; # two finger right click
      TrackpadThreeFingerDrag = true;
    };
  };
}

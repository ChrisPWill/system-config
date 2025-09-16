{...}: {
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Auto upgrade nix package
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    autoMigrate = true;

    user = "cwilliams";
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [
      # TODO: Fix this error
      # Error: Cannot install in Homebrew on ARM processor in Intel default prefix (/usr/local)!
      # Please create a new installation in /opt/homebrew using one of the
      # "Alternative Installs" from:
      #   https://docs.brew.sh/Installation
      # You can migrate your previously installed formula list with:
      #   brew bundle dump

      # "tfenv"
      "awscli"
    ];
    taps = [
      "nikitabobko/tap"
      {
        name = "atlassian/lanyard";
        clone_target = "git@bitbucket.org:atlassian/lanyard-tap.git";
      }
    ];
    casks = [
      "alacritty"
      "amethyst"
      "docker-desktop"

      # Another modern terminal replacement
      "ghostty"

      "insomnia"
      "obsidian"
      "raycast"
      "scroll-reverser"
      "spotify"
      "visual-studio-code"

      # Window manager
      "aerospace"

      # A notes app, more for outlining than obsidian
      "logseq"

      # Keystroke overlay for demos
      "keycastr"

      # AI coder
      "cursor"

      # For testing Atlassian service calls
      "lanyard"
    ];
  };

  system.primaryUser = "cwilliams";

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

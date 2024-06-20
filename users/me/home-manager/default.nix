{
  me ? "cwilliams",
  fullName ? "Chris Williams",
  email ? "chris@chrispwill.com",
  stateVersion ? "24.05",
}: {
  inputs,
  lib,
  pkgs,
  ...
}
: let
  isLinux = pkgs.stdenv.isLinux;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./alacritty.nix # simple, fast terminal https://github.com/alacritty/alacritty
    ./nixvim # neovim config system https://github.com/nix-community/nixvim
    ./vscode.nix # editor for when I pair or need better debugger setup
    ./zellij.nix # terminal multiplexer
    ./zsh.nix # shell, you know where to find it
  ];

  options = {
    home.fullName = lib.mkOption {
      type = lib.types.string;
      default = fullName;
      description = "Full name of the current user";
    };
    home.email = lib.mkOption {
      type = lib.types.string;
      default = email;
      description = "Email of the current user";
    };
  };

  config = {
    home = {
      username = me;
      stateVersion = stateVersion;

      packages = with pkgs;
        [
          # Fast alternative to find
          # https://github.com/sharkdp/fd
          fd

          # Terminal JSON viewer
          # https://fx.wtf/
          fx

          # Notes app
          # https://obsidian.md/
          obsidian

          # Fancy prompt for zsh
          # https://github.com/justjanne/powerline-go
          powerline-go

          # xargs + awk with pattern matching
          # https://github.com/lotabout/rargs
          rargs

          # Runs with "tldr" - quick facts about an app
          # https://github.com/dbrgn/tealdeer
          tealdeer

          # A good font
          (nerdfonts.override {fonts = ["FantasqueSansMono"];})
        ]
        ++ lib.optionals isLinux [
          eww
          gnome.nautilus
          gnome.sushi
          swaybg
        ];
    };

    programs = {
      home-manager.enable = true;

      # Nice colourful cat alternative
      # https://github.com/sharkdp/bat
      bat = {
        enable = true;

        config = {
          theme = "TwoDark";
        };
      };

      # ls alternative
      # https://github.com/eza-community/eza
      eza = {
        enable = true;
        git = true;
        icons = true;
      };

      # The best browser.
      # Buggy on MacOS so we'll just manage it with homebrew
      firefox.enable = isLinux;

      # Command line fuzzy finder
      # https://github.com/junegunn/fzf
      # Hotkeys:
      # CTRL-T find a file/dir and put it in command line
      # CTRL-R search command history
      # ALT-C to cd into a subdir
      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --hidden";
        changeDirWidgetCommand = "fd --type d";
        fileWidgetCommand = "fd --type f";
      };

      # Grep alternative. Utility of the year, every year.
      # https://github.com/BurntSushi/ripgrep
      ripgrep.enable = true;

      # Nice fast autojump command
      # https://github.com/ajeetdsouza/zoxide
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      # Lightweight video player
      mpv.enable = true;

      wofi.enable = isLinux;
    };

    fonts.fontconfig.enable = true;
  };
}

{
  me ? "cwilliams",
  fullName ? "Chris Williams",
  email ? "chris@chrispwill.com",
  stateVersion ? "24.05",
}: {
  inputs,
  lib,
  ...
}
: {
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

      # The best browser
      firefox.enable = true;

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
    };
  };
}

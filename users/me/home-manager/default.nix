{
  me ? "cwilliams",
  fullName ? "Chris Williams",
  email ? "chris@chrispwill.com",
  stateVersion ? "24.05",
  isPersonalMachine ? false,
  isWsl ? false,
  extraHomeModules ? [],
  ...
}: {
  inputs,
  lib,
  pkgs,
  config,
  ...
}
: let
  isLinux = pkgs.stdenv.isLinux && !config.home.isWsl;
  isDarwin = pkgs.stdenv.isDarwin;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./alacritty.nix # simple, fast terminal https://github.com/alacritty/alacritty
    ./wezterm.nix # exploring this as alacritty alternative https://wezfurlong.org/wezterm/index.html
    ./nixvim # neovim config system https://github.com/nix-community/nixvim
    ./vscode.nix # editor for when I pair or need better debugger setup
    ./helix.nix # https://helix-editor.com/ - trying this out as an alternative to vim
    ./zellij.nix # terminal multiplexer
    ./zsh.nix # shell, you know where to find it
    ./nushell.nix # a newer shell to try out
    ./window-manager # contains config for hyprland, widgets, etc.
    ./git.nix # yep
  ];

  options = {
    outOfStore = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.dotfiles/out-of-store";
      example = "${config.home.homeDirectory}/.dotfiles/out-of-store";
      description = "Location of the directory for out-of-store files";
    };
    home.fullName = lib.mkOption {
      type = lib.types.str;
      default = fullName;
      description = "Full name of the current user";
    };
    home.email = lib.mkOption {
      type = lib.types.str;
      default = email;
      description = "Email of the current user";
    };
    home.isPersonalMachine = lib.mkOption {
      type = lib.types.bool;
      default = isPersonalMachine;
      description = "Is this a personal machine";
    };
    home.isWsl = lib.mkOption {
      type = lib.types.bool;
      default = isWsl;
      description = "Is this a WSL instance?";
    };
  };

  config = lib.mkMerge ([
      {
        home = {
          username = me;
          stateVersion = stateVersion;
          homeDirectory =
            if isDarwin
            then "/Users/${me}"
            else "/home/${me}";

          packages = with pkgs;
            [
              # {bash,zsh,fish,powershell,nushell}-completions for 1000+ commands
              # https://github.com/sigoden/argc-completions
              argc

              # Command-line YAML/XML/TOML processor
              # Dependency of argc
              # https://github.com/kislyuk/yq
              yq

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

              # Runs with "tldr" - quick facts about an app
              # https://github.com/dbrgn/tealdeer
              tealdeer

              python3

              # A good font
              nerd-fonts.fantasque-sans-mono
            ]
            ++ lib.optionals isLinux [
              nautilus
              sushi
              swaybg

              # Another notes app, more for outlining
              logseq

              # Secure messenger
              signal-desktop
            ]
            ++ lib.optionals (config.home.isPersonalMachine && !config.home.isWsl) [
              discord
            ];

          file = with lib;
            mkMerge [
              (
                if (pkgs.stdenv.isDarwin)
                then {
                  ".aerospace.toml".source = ./config-files/aerospace.toml;
                }
                else {
                }
              )
              {
                ".local/nixBin" = {
                  source = config.lib.file.mkOutOfStoreSymlink "${config.outOfStore}/bin";
                };
              }
            ];
        };

        home.sessionPath = ["${config.home.homeDirectory}/.local/nixBin"];

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

          # https://direnv.net/
          # https://github.com/nix-community/nix-direnv
          direnv = {
            enable = true;
            enableZshIntegration = true;
            # enableNushellIntegration = true;
            nix-direnv.enable = true;
          };

          # ls alternative
          # https://github.com/eza-community/eza
          eza = {
            enable = true;
            # enableNushellIntegration = true;
            git = true;
            icons = "auto";
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
            # enableNushellIntegration = true;
          };

          # Lightweight video player
          mpv.enable = isLinux; # isLinux because of https://github.com/NixOS/nixpkgs/issues/327836 - can remove later

          wofi.enable = isLinux;
        };

        fonts.fontconfig.enable = true;
      }
    ]
    ++ extraHomeModules);
}

{
  pkgs,
  lib,
  theme,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      brightnessctl
      libnotify
    ];

    # locks
    programs.swaylock = {
      enable = true;
      settings = {
        color = "#764783";
        daemonize = true;
        clock = true;
        ignore-empty-password = true;
      };
    };
    services.flameshot.enable = true;
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof swaylock || swaylock -f";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
        };

        listener = [
          # monitor backlight
          # {
          #   timeout = 150;
          #   on-timeout = "brightnessctl -s set 10";
          #   on-resume = "brightnessctl -r";
          # }
          # keyboard backlight
          # {
          #   timeout = 150;
          #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          #   on-resume = "brightnessctl -rd rgb:kbd_backlight";
          # }
          # warn after 4.75 minutes
          {
            # timeout = 285;
            timeout = 285;
            on-timeout = "notify-send \"About to lock\" \"Move the mouse or it'll lock\"";
          }
          # lock after 5 minutes
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          # screen off after 5.5 minutes
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dkms off";
            on-resume = "hyprctl dispatch dkms on";
          }
          # sleep
          {
            timeout = 900; # 15 minutes
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    # notifications
    services.swaync.enable = true;

    services.swayidle = {
      enable = false;
      events = [
        {
          event = "lock";
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          event = "after-resume";
          command = "${pkgs.hyprland}/bin/hyprctl \"dispatcher dpms on\"";
        }
      ];
      timeouts = [
        {
          timeout = 600;
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          timeout = 1200;
          command = "${pkgs.hyprland}/bin/hyprctl \"dispatcher dpms off\"";
        }
      ];
    };
    wayland.windowManager.hyprland = {
      enable = true;
      # enableNvidiaPatches = true;
      extraConfig = import ./hyprlandExtraConfig.nix {inherit pkgs theme;};
    };
  };
}

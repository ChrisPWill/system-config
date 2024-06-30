{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        color = "#764783";
        daemonize = true;
        clock = true;
        ignore-empty-password = true;
        screenshots = true;
        fade-in = 1;
        effect-blur = "10x10";
      };
    };

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          # check if swaylock is already active, if not, lock
          lock_cmd = "pidof swaylock || ${pkgs.swaylock-effects}/bin/swaylock -f";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl \"dispatch dpms on\"";
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
            on-timeout = "${pkgs.hyprland}/bin/hyprctl \"dispatch dkms off\"";
            on-resume = "${pkgs.hyprland}/bin/hyprctl \"dispatch dkms on\"";
          }
          # sleep
          {
            timeout = 900; # 15 minutes
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}

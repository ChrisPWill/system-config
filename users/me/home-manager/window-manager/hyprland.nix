{agsHomePath, ...}: {
  pkgs,
  lib,
  theme,
  config,
  ...
}: let
  toRgb = theme.utils.toRgb;
  colors = theme.normal;
in {
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      entr
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      # enableNvidiaPatches = true;
      # extraConfig = import ./hyprlandExtraConfig.nix {inherit pkgs theme;};

      settings = {
        exec-once = [
          "swaybg -i ~/.config/wallpapers/safe.* -m fill &"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "wlsunset -l -33.86 -L 151.2" # makes screen orange
          "rg --files ${agsHomePath} | entr -r ags"
        ];

        env = "WLR_DRM_DEVICES,$HOME/.config/hypr/card:/dev/dri/card0";

        general = {
          gaps_in = 5;
          gaps_out = 7;
          border_size = 2;
          "col.active_border" = "${toRgb (colors.green)}";
          "col.inactive_border" = "${toRgb (colors.lightgray)}";
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        decoration = {
          rounding = 5;
        };

        bezier = "overshot,0.05,0.9,0.1,1.1";
        animation = [
          "workspaces,1,8,overshot,fade"
          "windows,1,3,overshot,slide"
        ];

        input = {
          kb_layout = "us";
          follow_mouse = 1;
        };

        # binds
        "$mod" = "CTRL_ALT";
        bind =
          [
            # applications
            "$mod,return,exec,alacritty" # terminal
            "$mod,r,exec,wofi --show drun" # launcher

            # window management
            "$mod,c,killactive"
            "$mod,m,exit"
            "$mod,p,pin"
            "$mod,f,fullscreen,0"
            "$mod,space,togglefloating"

            # VIM navigation for windows
            "CTRL_ALT,h,movefocus,l"
            "CTRL_ALT,j,movefocus,d"
            "CTRL_ALT,k,movefocus,u"
            "CTRL_ALT,l,movefocus,r"
            "CTRL_ALT_SHIFT,right,resizeactive,10 0"
            "CTRL_ALT_SHIFT,left,resizeactive,-10 0"
            "CTRL_ALT_SHIFT,up,resizeactive,0 -10"
            "CTRL_ALT_SHIFT,down,resizeactive,0 10"

            # locks
            "$mod,q,exec,swaylock"

            # workspace to monitor
            "$mod SUPER, 1, movecurrentworkspacetomonitor, 0"
            "$mod SUPER, 2, movecurrentworkspacetomonitor, 1"
            "$mod SUPER, 3, movecurrentworkspacetomonitor, 2"
          ]
          ++ (
            # workspaces
            builtins.concatLists (builtins.genList (
                x: [
                  "$mod, ${
                    if x + 1 != 10
                    then toString (x + 1)
                    else "0"
                  }, workspace, ${toString (x + 1)}"
                  "$mod SHIFT,  ${
                    if x + 1 != 10
                    then toString (x + 1)
                    else "0"
                  }, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );

        bindm = [
          "$mod,mouse:272,movewindow"
          "$mod,mouse:273,resizewindow"
        ];

        windowrule = [
          "opacity 0.85,alacritty"
        ];

        windowrulev2 = [
          "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
        ];

        monitor = [
          "DP-4,3840x2160,0x0,1"
          "HDMI-A-3,2560x1440,3840x360,1"
        ];

        workspace =
          []
          ++ (
            builtins.genList (
              x:
                builtins.concatStringsSep "," [
                  (toString (x + 1))
                  "monitor:${
                    if (x + 1) <= 5
                    then "desc:LG Electronics LG HDR 4K 112NTYTMG434"
                    else "desc:Ancor Communications Inc ASUS MG279 0x0002843F"
                  }"
                  "${
                    if (x + 1) == 1 || (x + 1) == 6
                    then ", default:true"
                    else ""
                  }"
                  "persistent:true"
                ]
            )
            11
          );
      };
    };
  };
}

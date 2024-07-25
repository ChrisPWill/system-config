{
  pkgs,
  lib,
  theme,
  ...
}: let
  toRgb = theme.utils.toRgb;
  colors = theme.normal;
in {
  config = lib.mkIf pkgs.stdenv.isLinux {
    wayland.windowManager.hyprland = {
      enable = true;
      # enableNvidiaPatches = true;
      # extraConfig = import ./hyprlandExtraConfig.nix {inherit pkgs theme;};

      settings = {
        exec-once = [
          "swaybg -i ~/.config/wallpapers/safe.* -m fill &"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
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

        bezier = "overshot,0.05,0.9,0.1,0.1";
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
        bind = [
          # applications
          "$mod,return,exec,alacritty" # terminal
          "$mod,r,exec,wofi --show drun" # launcher

          # window management
          "$mod,c,killactive"
          "$mod,m,exit"
          "$mod,p,pin"
          "$mod,f,fullscreen,0"
          "$mod SHIFT,f,fakefullscreen,0"
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
        ] ++ (
          # workspaces
          builtins.concatLists (builtins.genList (
            x: [
              "$mod, ${toString (x + 1)}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${toString (x + 1)}, movetoworkspace, ${toString (x + 1)}"
            ]
          ) 10)
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
      };
    };
  };
}

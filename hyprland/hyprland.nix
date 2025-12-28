{
  pkgs,
  inputs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  home.sessionVariables = {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = 24;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.rose-pine-cursor; # Note: use the XCursor version for GTK
    name = "BreezX-RosePine-Linux";
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # Use the same flake package as configuration.nix
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,24"
      ];
      "exec-once" = [
        "hyprctl setcursor rose-pine-hyprcursor 24"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "waybar"
        "swaync"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, M, exit"
        # mod space - app launcher
        "$mod, SPACE, exec, rofi -show drun"
        # mod v - Show copy history in rofi
        "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        # --- Move Windows (Swap window positions) ---
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        # --- Move Focus (Switch active window) ---
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ];

      monitor = [
        # Right Monitor (DP-1): 1440p, Landscape
        # Positioned at X=2160 (width of rotated 4K) and Y=1200 (centered vertically)
        "DP-1, 2560x1440@165, 2160x1200, 1"

        # Left Monitor (DP-2): 4K, Portrait Right, positioned at 0,0
        # transform 3 = 270 degrees (Portrait Right)
        "DP-2, 3840x2160@60, 0x0, 1, transform, 1"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        # Added output here so it shows only on the main monitor
        output = ["DP-1"];

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "pulseaudio" "temperature" "custom/gpu-temp" "network" "custom/notification" "tray"];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "default" = "○";
            "active" = "●";
            "urgent" = "!";
          };
        };

        "clock" = {
          interval = 1; # REQUIRED for seconds to tick
          format = "{:%I:%M:%S %p}";
          on-click = "gnome-calendar";
        };

        "temperature" = {
          "hwmon-path" = "/sys/class/hwmon/hwmon4/temp1_input";
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C ";
          "interval" = 2; # This forces it to run every 2 seconds
        };

        "custom/gpu-temp" = {
          "exec" = "cat /sys/class/hwmon/hwmon1/temp1_input | awk '{print $1/1000}'";
          "interval" = 2;
          "format" = "{}°C 󰢮";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}󰂰";
          format-muted = "󰝟";
          format-icons = {
            "headphone" = "";
            "hands-free" = "󱡒";
            "headset" = "󰋎";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          on-click = "pavucontrol";
          # Scroll up/down on the bar to change volume
          "on-scroll-up" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "smooth-scrolling-threshold" = 1;
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw"; # Toggle and Stay Windowed
          "on-click-right" = "swaync-client -C"; # Clear notifications
          "escape" = true;
        };

        "network" = {
          format-wifi = "{essid} ";
          format-ethernet = "󰈀";
          format-disconnected = "⚠";
          on-click = "nm-connection-editor";
        };

        "cpu" = {
          format = "{usage}% ";
        };

        "memory" = {
          format = "{}% ";
        };
      };
    };

    style = builtins.readFile ./waybar.css;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "android_notification";
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window ";
      sidebar-mode = true;
    };
  };

  home.packages = with pkgs; [
    swaynotificationcenter #notifications
    pavucontrol # volume control
    rofi # applauncher
    waybar # The most popular status bar for Hyprland
    wl-clipboard
    cliphist
    rose-pine-hyprcursor
  ];
}

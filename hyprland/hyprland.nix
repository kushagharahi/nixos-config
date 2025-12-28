{
  pkgs,
  inputs,
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
    XCURSOR_THEME = "BreezX-RosePine-Linux";
    XCURSOR_SIZE = 24;
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.rose-pine-cursor; # Note: use the XCursor version for GTK
    name = "BreezeX-RosePine-Linux";
    size = 24;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # Use the same flake package as configuration.nix
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      "exec-once" = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${inputs.ashell.packages.${pkgs.system}.default}/bin/ashell"
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
        # Screenshots
        "$mod SHIFT, S, exec, hyprshot -m window"
        "$mod, R, exec, hyprshot -m region"
        "$mod SHIFT, R, exec, hyprshot -m region --clipboard-only"
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

  xdg.configFile."ashell/config.toml".text = ''
    log_level = "warn"
    outputs = { Targets = ["DP-1"] }
    position = "Top"

    [modules]
    left = [ [ "Workspaces" ] ]
    center = [ "WindowTitle" ]
    right = [ "SystemInfo", ["Clock", "media_player", "Privacy", "Settings", "Tray" ] ]

    [workspaces]
    enable_workspace_filling = true

    [window_title]
    truncate_title_after_length = 100

    [system_info]
    indicators = ["Cpu", "Memory", "Temperature", "UploadSpeed", "DownloadSpeed"]

    [settings]
    lock_cmd = "playerctl --all-players pause; nixGL hyprlock &"
    audio_sinks_more_cmd = "pavucontrol -t 3"
    audio_sources_more_cmd = "pavucontrol -t 4"
    wifi_more_cmd = "nm-connection-editor"
    vpn_more_cmd = "nm-connection-editor"
    bluetooth_more_cmd = "blueberry"

    [appearance]
    style = "Islands"
    primary_color = "#7aa2f7"
    success_color = "#9ece6a"
    text_color = "#a9b1d6"
    workspace_colors = [ "#7aa2f7", "#9ece6a" ]
    special_workspace_colors = [ "#7aa2f7", "#9ece6a" ]

    [appearance.danger_color]
    base = "#f7768e"
    weak = "#e0af68"

    [appearance.background_color]
    base = "#1a1b26"
    weak = "#24273a"
    strong = "#414868"

    [appearance.secondary_color]
    base = "#0c0d14"
  '';

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
    inputs.ashell.packages.${pkgs.system}.default
    swaynotificationcenter #notifications
    pavucontrol # volume control
    rofi # applauncher
    wl-clipboard
    cliphist
    rose-pine-hyprcursor
    blueberry
    hyprshot #screenshots
  ];
}

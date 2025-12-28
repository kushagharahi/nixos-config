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
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    font = {
      name = "Inter";
      size = 12;
    };
  };

  # Also set the "prefer-dark" hint for modern Libadwaita/GTK4 apps
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Inter"];
      sansSerif = ["Inter"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };

  home.sessionVariables = {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = 24;
    XCURSOR_THEME = "BreezX-RosePine-Linux";
    XCURSOR_SIZE = 24;
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # Force apps to look for the tray
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Fix for Electron apps (Discord/Spotify)
    NIXOS_OZONE_WL = "1";
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
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  xdg.configFile."ashell/config.toml".source = ./ashell-config.toml;

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
    inputs.ashell.packages.${pkgs.system}.default # top bar
    swaynotificationcenter #notifications
    pavucontrol # volume control
    rofi # applauncher
    wl-clipboard # copy paste engine
    cliphist # clipboard manager
    rose-pine-hyprcursor # cursor theme
    hyprshot #screenshots
    swaybg # wallpaper management
  ];
}

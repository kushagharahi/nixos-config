{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # Global Catppuccin Setting
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  catppuccin.cursors = {
    enable = true;
    flavor = "mocha";
    accent = "dark";
  };

  gtk = {
    enable = true;
    catppuccin.cursor.enable = true;
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
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # Force apps to look for the tray
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Fix for Electron apps (Discord/Spotify)
    NIXOS_OZONE_WL = "1";
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

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      scrollback_lines = 10000;
    };
    extraConfig = ''
      # Any raw kitty.conf text goes here
      background_opacity 0.9
    '';
  };

  home.packages = with pkgs; [
    inputs.ashell.packages.${pkgs.system}.default # top bar
    swaynotificationcenter #notifications
    pavucontrol # volume control
    rofi # applauncher
    wl-clipboard # copy paste engine
    cliphist # clipboard manager
    hyprshot #screenshots
    swaybg # wallpaper management
  ];
}

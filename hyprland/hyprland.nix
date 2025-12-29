{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # Global Catppuccin Setting
  catppuccin = {
    enable = true;
    flavor = "mocha";
    cursors = {
      enable = true;
      flavor = "mocha";
      accent = "dark";
    };
  };

  gtk = {
    enable = true;
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

  home.pointerCursor = {
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    HYPRCURSOR_SIZE = 24;
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
      tab_bar_edge top
      tab_bar_style powerline
      tab_powerline_style slanted
      remember_window_size  yes
      remember_window_position yes
    '';
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          path = "$HOME/nixos-config/wallpapers/login.png";
          blur_passes = 2;
        }
      ];
    };
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
    hyprlock # lock screen
    hyprsunset # night shift
  ];
}

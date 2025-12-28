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

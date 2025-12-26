{ pkgs, ... }:

{
  # Home Manager needs this to know what version it's managing
  home.stateVersion = "25.11"; 

  programs.git = {
    enable = true;
    userName  = "kushagharahi";
    userEmail = "3326002+kushagharahi@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/kusha/nixos-config";
    };
  };

  
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, Q, exec, kitty"
          "$mod, F, exec, firefox"
        ];
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  # You can add more user-level packages here
  home.packages = with pkgs; [
  ];
}

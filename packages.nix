{
  pkgs,
  lib,
  ...
}: {
  # Allow specific unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "discord"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  # List your packages here
  home-manager.users.kusha = {
    # This MUST be an attribute set, not just a list
    home.packages = with pkgs; [
      nixd
      unzip
      alejandra
      spotify
      discord
      gnomeExtensions.wireguard-vpn-extension
      ente-auth
      gimp
      prusa-slicer
      signal-desktop
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true; # Necessary for mouse/keyboard emulation
    openFirewall = true; # Opens 47984-47990, 48010, etc.
  };
}

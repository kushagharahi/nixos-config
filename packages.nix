{
  pkgs,
  lib,
  ...
}: let
  unstable-pkgs =
    import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/5978570be8393ec3bc10bc4096523f9186587fb5.tar.gz";
      sha256 = "173ami7yba40pn2cmcc0j6xmbwwlxz82frc31lblclg9a5cidlym";
    }) {
      system = pkgs.stdenv.hostPlatform.system;
      config = {};
    };
in {
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
      # gui - free
      ente-auth
      gimp
      prusa-slicer
      vlc
      remmina

      # gui - non-free
      spotify
      discord
      signal-desktop

      # cmd line
      kubectl
      amdgpu_top
      htop
      unzip
      yazi # file manager TUI

      # programming
      nixd # NIX LSP
      alejandra # NIX Code formatter

      # core (maybe this should be moved)
      gnomeExtensions.wireguard-vpn-extension
      (pkgs.symlinkJoin {
        name = "easyeffects-with-plugins";
        paths = [
          unstable-pkgs.easyeffects # Official modern version (no compiling)
          unstable-pkgs.x42-plugins # Matching autotune engine
          pkgs.lsp-plugins # Adds the deep vocoder engine
          pkgs.mda_lv2 # Adds the classic stompbox-style Talkbox
        ];
      })
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

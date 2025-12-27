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
    ];

  # List your packages here
  home-manager.users.kusha = {
    # This MUST be an attribute set, not just a list
    home.packages = with pkgs; [
      nixd
      alejandra
      spotify
      discord
      steam
      wireguard-ui # The UI tool
      wireguard-tools # The CLI tools required for the UI to function
    ];
  };
}

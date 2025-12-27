{pkgs, ...}: {
  # Home Manager needs this to know what version it's managing
  home.stateVersion = "25.11";

  imports = [
    ./dconf.nix
  ];

  programs.bash = {
    enable = true;
  };

  home.shellAliases = {
    "code" = "codium";
  };

  programs.git = {
    enable = true;
    userName = "kushagharahi";
    userEmail = "3326002+kushagharahi@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/kusha/nixos-config";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    # These extensions will be auto-installed
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide # The main Nix support
    ];

    # This replaces manually editing settings.json
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "alejandra";
      "editor.formatOnSave" = true;

      # Tell nixd where your flake is for better autocomplete
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {"command" = ["alejandra"];};
          "options" = {
            "nixos" = {
              "expr" = "(builtins.getFlake \"/home/kusha/nixos-config\").nixosConfigurations.nixos.options";
            };
          };
        };
      };
    };
  };
}

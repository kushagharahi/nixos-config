{
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs this to know what version it's managing
  home.stateVersion = "25.11";

  imports = [
    ./hyprland/hyprland.nix
  ];

  programs.bash = {
    enable = true;
  };

  home.shellAliases = {
    "code" = "codium";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "kushagharahi";
        email = "3326002+kushagharahi@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      safe.directory = "/home/kusha/nixos-config";
      # This ensures that 'git pull' uses rebase instead of creating a merge commit
      pull.rebase = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    # This replaces manually editing settings.json
    profiles.default = {
      # These extensions will be auto-installed
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide # The main Nix support
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "alejandra";
        "editor.wordWrap" = "on";
        "editor.fontFamily" = "JetBrainsMonoNL Nerd Font Mono";
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
  };

  programs.mangohud = {
    enable = true;
    # This replaces the need for MANGOHUD_CONFIG in Steam launch options
    settings = {
      # Disable the GameMode text detection
      gamemode = 0;

      # Aesthetics
      legacy_layout = false;
      gpu_stats = true;
      cpu_stats = true;
      ram = true;
      vram = true;
      fps = true;
      frame_timing = false;
    };
  };
}

{
  description = "My NixOS Flake Configuration";

  inputs = {
    # This pulls the 25.11 version of Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # This pulls Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland.url = "git+file:///home/kusha/projects/Hyprland";
    hyprland.url = "github:hyprwm/Hyprland/v0.54.0";
    #ashell.url = "github:MalpenZibo/ashell";
    ashell.url = "path:/home/kusha/projects/ashell";
    catppuccin.url = "github:catppuccin/nix/release-25.11";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    ...
  } @ inputs: {
    # Replace 'nixos' with your actual hostname (usually 'nixos')
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;}; # This passes inputs to your modules
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.kusha = import ./home.nix;
        }
        lanzaboote.nixosModules.lanzaboote
        ./modules/lanza.nix
      ];
    };
  };
}

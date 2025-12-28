{
  description = "My NixOS Flake Configuration";

  inputs = {
    # This pulls the 25.11 version of Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # This pulls Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    #ashell.url = "github:MalpenZibo/ashell";
    ashell.url = "path:/home/kusha/ashell";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
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
      ];
    };
  };
}
